same_family <- function(a, b) {
  fa <- parse_model(a)$family
  fb <- parse_model(b)$family
  fa == fb
}

compare_models <- function(a, b) {
  pa <- parse_model(a)
  pb <- parse_model(b)
  na <- nrow(pa)
  nb <- nrow(pb)
  if (na == 0L || nb == 0L) {
    return(integer())
  }
  n <- max(na, nb)
  if (n %% na != 0L || n %% nb != 0L) {
    warning("longer argument not a multiple of length of shorter",
            call. = FALSE)
  }
  ia <- rep_len(seq_len(na), n)
  ib <- rep_len(seq_len(nb), n)
  vapply(seq_len(n), function(k) compare_rows(pa, ia[k], pb, ib[k]),
         integer(1L))
}

latest_model <- function(ids, family) {
  if (!is.character(family) || length(family) != 1L || is.na(family)) {
    stop("'family' must be a single string", call. = FALSE)
  }
  p <- parse_model(ids)
  keep <- which(!is.na(p$family) & p$family == family)
  if (length(keep) == 0L) {
    return(NA_character_)
  }
  best <- keep[1L]
  for (k in keep[-1L]) {
    if (compare_rows(p, k, p, best) > 0L) {
      best <- k
    }
  }
  p$id[best]
}

# compare_rows orders row i of pa against row j of pb, oldest first.
# Version wins, then the full date, then the short date code. A missing
# date counts as older than any date, like Go's zero time.
compare_rows <- function(pa, i, pb, j) {
  if (is.na(pa$id[i]) || is.na(pb$id[j])) {
    return(NA_integer_)
  }
  r <- natural(pa$version[i], pb$version[j])
  if (r != 0L) {
    return(r)
  }
  da <- pa$date[i]
  db <- pb$date[j]
  if (is.na(da) != is.na(db)) {
    return(if (is.na(da)) -1L else 1L)
  }
  if (!is.na(da) && da != db) {
    return(if (da < db) -1L else 1L)
  }
  natural(pa$snapshot[i], pb$snapshot[j])
}

# natural compares strings with runs of digits compared as numbers,
# so "3.10" sorts after "3.9" and "k3" after "k2.7".
natural <- function(a, b) {
  while (nzchar(a) && nzchar(b)) {
    ca <- chunk(a)
    cb <- chunk(b)
    r <- compare_chunk(ca[1L], cb[1L])
    if (r != 0L) {
      return(r)
    }
    a <- ca[2L]
    b <- cb[2L]
  }
  if (a == b) {
    0L
  } else if (!nzchar(a)) {
    -1L
  } else {
    1L
  }
}

# chunk splits off the leading run of digits or non-digits.
chunk <- function(s) {
  head <- regmatches(s, regexpr("^([0-9]+|[^0-9]+)", s, perl = TRUE))
  c(head, substring(s, nchar(head) + 1L))
}

compare_chunk <- function(a, b) {
  if (starts_with_digit(a) && starts_with_digit(b)) {
    a <- trim_zeros(a)
    b <- trim_zeros(b)
    if (nchar(a) != nchar(b)) {
      return(if (nchar(a) < nchar(b)) -1L else 1L)
    }
  }
  compare_bytes(a, b)
}

trim_zeros <- function(s) {
  sub("^0+(.)", "\\1", s, perl = TRUE)
}

# compare_bytes compares like Go's < on strings, byte by byte, so the
# result doesn't depend on the locale's collation order.
compare_bytes <- function(a, b) {
  x <- as.integer(charToRaw(enc2utf8(a)))
  y <- as.integer(charToRaw(enc2utf8(b)))
  m <- min(length(x), length(y))
  d <- which(x[seq_len(m)] != y[seq_len(m)])
  if (length(d) > 0L) {
    return(if (x[d[1L]] < y[d[1L]]) -1L else 1L)
  }
  if (length(x) == length(y)) {
    0L
  } else if (length(x) < length(y)) {
    -1L
  } else {
    1L
  }
}
