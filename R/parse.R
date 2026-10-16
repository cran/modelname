tag_words <- c(
  "preview", "latest", "exp", "experimental",
  "instruct", "thinking", "beta", "free"
)

parse_model <- function(x) {
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (!is.character(x)) {
    stop("'x' must be a character vector", call. = FALSE)
  }
  x <- unname(x)
  parts <- lapply(x, parse_one)
  field <- function(name) {
    vapply(parts, function(p) p[[name]], character(1L))
  }
  out <- data.frame(
    id = x,
    vendor = field("vendor"),
    family = field("family"),
    version = field("version"),
    size = field("size"),
    date = as.Date(field("date"), format = "%Y-%m-%d"),
    snapshot = field("snapshot"),
    stringsAsFactors = FALSE
  )
  out$tags <- lapply(parts, function(p) p$tags)
  out
}

# parse_one splits a single model ID or display name into its parts. It never
# fails; anything it doesn't recognise ends up in family.
parse_one <- function(id) {
  if (is.na(id)) {
    return(list(
      vendor = NA_character_, family = NA_character_,
      version = NA_character_, size = NA_character_, date = NA_character_,
      snapshot = NA_character_, tags = character()
    ))
  }

  version <- ""
  size <- ""
  date <- NA_character_
  snapshot <- ""
  tags <- character()

  s <- tolower(gsub("^[\\h\\v]+|[\\h\\v]+$", "", id, perl = TRUE))

  # OpenRouter style suffixes, e.g. ":free" or ":thinking".
  colon <- regexpr(":", s, fixed = TRUE)
  if (colon > 0L) {
    rest <- strsplit(substring(s, colon + 1L), ":", fixed = TRUE)[[1L]]
    tags <- rest[nzchar(rest)]
    s <- substr(s, 1L, colon - 1L)
  }

  prefix <- ""
  slashes <- gregexpr("/", s, fixed = TRUE)[[1L]]
  if (slashes[1L] > 0L) {
    last <- max(slashes)
    prefix <- substr(s, 1L, last - 1L)
    s <- substring(s, last + 1L)
  }

  toks <- tokenize(s)
  n <- length(toks)
  words <- character()
  i <- 1L
  while (i <= n) {
    t <- toks[i]
    glued <- if (!nzchar(version) && i == 1L) split_glued(t) else ""
    if (i + 2L <= n && is_year(t) && is_digits(toks[i + 1L], 2L) &&
      is_digits(toks[i + 2L], 2L)) {
      d <- parse_ymd(paste0(t, toks[i + 1L], toks[i + 2L]))
      if (!is.na(d)) {
        date <- d
        i <- i + 3L
        next
      }
      snapshot <- t
    } else if (is_digits(t, 8L)) {
      d <- parse_ymd(t)
      if (!is.na(d)) {
        date <- d
      } else {
        snapshot <- t
      }
    } else if (is_size(t)) {
      size <- t
      if (i + 1L <= n && is_active(toks[i + 1L])) {
        size <- paste0(size, "-", toks[i + 1L])
        i <- i + 1L
      }
    } else if (t %in% tag_words) {
      tags <- c(tags, t)
    } else if (!nzchar(version) && starts_with_digit(t) && !is_long_number(t)) {
      version <- t
      ab <- absorb(version, toks, i)
      version <- ab$version
      i <- ab$i
    } else if (nzchar(glued)) {
      # qwen3.5, hy3
      words <- c(words, substr(t, 1L, nchar(t) - nchar(glued)))
      ab <- absorb(glued, toks, i)
      version <- ab$version
      i <- ab$i
    } else if (!nzchar(version) && i > 1L && is_letter_version(t)) {
      # v3.2, k2, m2, mk1
      version <- t
      if (substr(t, 1L, 1L) == "v" && starts_with_digit(substring(t, 2L))) {
        version <- substring(t, 2L)
      }
      ab <- absorb(version, toks, i)
      version <- ab$version
      i <- ab$i
    } else if (is_long_number(t)) {
      snapshot <- t
    } else if (nzchar(version) && is_digits(t, 1:2)) {
      # stray numbers after the name, like the 03-25 in gemini-2.5-pro-exp-03-25
      snapshot <- if (nzchar(snapshot)) paste0(snapshot, "-", t) else t
    } else {
      words <- c(words, t)
    }
    i <- i + 1L
  }

  list(
    vendor = vendor_for(prefix, words),
    family = paste(words, collapse = "-"),
    version = version,
    size = size,
    date = date,
    snapshot = snapshot,
    tags = tags
  )
}

# absorb joins dash-separated version parts, so claude-opus-4-1 reads as 4.1.
absorb <- function(version, toks, i) {
  n <- length(toks)
  while (i + 1L <= n && is_digits(toks[i + 1L], 1:2)) {
    version <- paste0(version, ".", toks[i + 1L])
    i <- i + 1L
  }
  list(version = version, i = i)
}

tokenize <- function(s) {
  f <- strsplit(s, "[-_ ()]", perl = TRUE)[[1L]]
  f <- gsub("^[.,]+|[.,]+$", "", f, perl = TRUE)
  f[nzchar(f)]
}

# is_digits reports whether t is all digits and has one of the given lengths.
is_digits <- function(t, lengths) {
  grepl("^[0-9]+$", t, perl = TRUE) && nchar(t) %in% lengths
}

is_year <- function(t) is_digits(t, 4L) && startsWith(t, "20")

# Three or more plain digits is a date code, not a version.
is_long_number <- function(t) is_digits(t, 3:7)

starts_with_digit <- function(t) grepl("^[0-9]", t, perl = TRUE)

# is_size matches parameter counts: 8b, 70b, 2.4t, 135m.
is_size <- function(t) {
  n <- nchar(t)
  n >= 2L && substr(t, n, n) %in% c("b", "m", "t") &&
    is_number(substr(t, 1L, n - 1L))
}

# is_active matches the active-parameter half of a MoE size, like a3b.
is_active <- function(t) {
  n <- nchar(t)
  n > 2L && substr(t, 1L, 1L) == "a" && substr(t, n, n) == "b" &&
    is_number(substr(t, 2L, n - 1L))
}

# A plain number with at most one dot, not starting or ending with one.
is_number <- function(t) grepl("^[0-9]+(\\.[0-9]+)?$", t, perl = TRUE)

first_digit <- function(t) as.integer(regexpr("[0-9]", t, perl = TRUE))

# split_glued returns the trailing version of a name like qwen3.5 or hy3.
# Single letters are left alone so o3 and r1 stay names.
split_glued <- function(t) {
  i <- first_digit(t)
  if (i < 3L) {
    return("")
  }
  rest <- substring(t, i)
  if (!is_versionish(rest)) {
    return("")
  }
  if (!grepl("^[a-z]+$", substr(t, 1L, i - 1L), perl = TRUE)) {
    return("")
  }
  rest
}

# is_letter_version matches v2.5, k2, m2, n2, mk1.
is_letter_version <- function(t) {
  i <- first_digit(t)
  if (i < 2L || i > 3L) {
    return(FALSE)
  }
  if (!grepl("^[a-z]+$", substr(t, 1L, i - 1L), perl = TRUE)) {
    return(FALSE)
  }
  is_versionish(substring(t, i))
}

is_versionish <- function(t) {
  is_number(gsub(".", "", t, fixed = TRUE)) && !endsWith(t, ".")
}

# parse_ymd reads an 8-digit date code. Like Go's time.Parse("20060102", s)
# it wants a real month and a real day, and returns NA otherwise.
parse_ymd <- function(s) {
  y <- as.integer(substr(s, 1L, 4L))
  mo <- as.integer(substr(s, 5L, 6L))
  d <- as.integer(substr(s, 7L, 8L))
  if (mo < 1L || mo > 12L || d < 1L) {
    return(NA_character_)
  }
  leap <- (y %% 4L == 0L && y %% 100L != 0L) || y %% 400L == 0L
  days <- c(31L, if (leap) 29L else 28L, 31L, 30L, 31L, 30L,
            31L, 31L, 30L, 31L, 30L, 31L)[mo]
  if (d > days) {
    return(NA_character_)
  }
  paste(substr(s, 1L, 4L), substr(s, 5L, 6L), substr(s, 7L, 8L), sep = "-")
}
