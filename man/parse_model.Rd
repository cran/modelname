\name{parse_model}
\alias{parse_model}
\title{Parse Model Names}
\description{
  Splits AI model identifiers and display names into vendor, family,
  version, parameter size, date, date code and tags. API identifiers such
  as \code{"gpt-4.1-mini"}, \samp{OpenRouter} style paths such as
  \code{"meta-llama/llama-3.3-70b-instruct:free"} and display names such as
  \code{"Gemini 3.1 Pro Preview"} are all read the same way.
}
\usage{
parse_model(x)
}
\arguments{
  \item{x}{A character vector of model identifiers or display names.
    Factors are converted to character.}
}
\details{
  Parsing is heuristic, not a registry lookup. It never fails: anything
  it does not recognise ends up in \code{family}, and fields that are not
  in the name are left empty. Old and new naming schemes land in the same
  family, so \code{"claude-3-5-sonnet-20241022"} and
  \code{"Claude Sonnet 4.5"} both have family \code{"claude-sonnet"}.

  The vendor comes from the prefix before the last \code{/} if there is
  one, otherwise from the first word of the family. Unknown first words
  give an empty vendor.
}
\value{
  A data frame with one row per element of \code{x} and these columns:
  \describe{
    \item{id}{The input, unchanged.}
    \item{vendor}{Who makes the model, such as \code{"anthropic"} or
      \code{"openai"}, or \code{""} if unknown.}
    \item{family}{Name words joined with \code{-}, such as
      \code{"gemini-flash-lite"}.}
    \item{version}{Version string, such as \code{"4.5"}, \code{"4o"} or
      \code{"k2.7"}.}
    \item{size}{Parameter count if given, such as \code{"70b"} or
      \code{"35b-a3b"}.}
    \item{date}{A \code{Date}, only set for full dates like
      \code{20241022}, otherwise \code{NA}.}
    \item{snapshot}{Short date codes like \code{"0731"} or \code{"2512"}.}
    \item{tags}{A list column of character vectors, such as
      \code{"preview"}, \code{"latest"}, \code{"thinking"} or the
      \code{":free"} suffix.}
  }
  Missing character fields are \code{""}. An \code{NA} input gives a row
  of \code{NA} values.
}
\seealso{
  \code{\link{compare_models}}, \code{\link{same_family}},
  \code{\link{latest_model}}
}
\examples{
parse_model("claude-opus-4-1-20250805")

m <- parse_model(c("gpt-4.1-mini", "meta-llama/llama-3.3-70b-instruct:free",
                   "Gemini 3.1 Pro Preview"))
m[, c("vendor", "family", "version", "size")]
m$tags
}
