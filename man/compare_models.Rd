\name{compare_models}
\alias{compare_models}
\title{Order Two Model Names}
\description{
  Orders two models from the same family, oldest first. The version wins,
  then the full date, then the short date code. Version parts are compared
  as numbers, so \code{"3.10"} is newer than \code{"3.9"} and
  \code{"k3"} is newer than \code{"k2.7"}.
}
\usage{
compare_models(a, b)
}
\arguments{
  \item{a, b}{Character vectors of model identifiers or display names.
    The shorter one is recycled.}
}
\details{
  Comparing across families works but does not mean much:
  \code{"gpt-5"} against \code{"claude-sonnet-4-5"} just compares 5 with
  4.5. Check \code{\link{same_family}} first if that matters.
}
\value{
  An integer vector: \code{-1} where \code{a} is older, \code{1} where
  \code{a} is newer and \code{0} where the two cannot be told apart.
  \code{NA} where either input is \code{NA}.
}
\seealso{
  \code{\link{parse_model}}, \code{\link{latest_model}}
}
\examples{
compare_models("gemini-3.9-flash", "gemini-3.10-flash")
compare_models("claude-opus-4-1-20250901", "claude-opus-4-1-20250805")
compare_models("gpt-5", "GPT-5")
}
