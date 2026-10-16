\name{same_family}
\alias{same_family}
\title{Check Whether Two Model Names Share a Family}
\description{
  Parses both arguments with \code{\link{parse_model}} and compares their
  \code{family} columns.
}
\usage{
same_family(a, b)
}
\arguments{
  \item{a, b}{Character vectors of model identifiers or display names.
    The shorter one is recycled.}
}
\value{
  A logical vector, \code{TRUE} where the two names parse to the same
  family. \code{NA} where either input is \code{NA}.
}
\seealso{
  \code{\link{parse_model}}, \code{\link{compare_models}}
}
\examples{
same_family("claude-3-5-sonnet-20241022", "Claude Sonnet 4.5")
same_family("gpt-4.1-mini", c("GPT-5.4 Mini", "gpt-4.1"))
}
