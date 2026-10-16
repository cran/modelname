\name{latest_model}
\alias{latest_model}
\title{Pick the Newest Model in a Family}
\description{
  Returns the newest identifier in \code{ids} whose family matches. Handy
  for picking a default out of a provider's model list.
}
\usage{
latest_model(ids, family)
}
\arguments{
  \item{ids}{A character vector of model identifiers or display names.}
  \item{family}{A single string, the family to look for, as returned in
    the \code{family} column of \code{\link{parse_model}}.}
}
\value{
  A single string, the element of \code{ids} that is newest according to
  \code{\link{compare_models}}, or \code{NA} if no element is in
  \code{family}. Ties go to the first one in \code{ids}.
}
\seealso{
  \code{\link{parse_model}}, \code{\link{compare_models}}
}
\examples{
ids <- c("claude-sonnet-4-5", "claude-3-7-sonnet-20250219",
         "claude-sonnet-4-6", "gpt-5")
latest_model(ids, "claude-sonnet")
latest_model(ids, "llama")
}
