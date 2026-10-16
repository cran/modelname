\name{modelname-package}
\alias{modelname-package}
\alias{modelname}
\docType{package}
\title{Parse AI Model Names into Vendor, Family and Version}
\description{
  Parses AI model identifiers and display names into parts you can
  compare. It is a port of the \samp{Go} module \samp{modelname}, with the
  same rules and the same test cases.
}
\details{
  \code{\link{parse_model}} does the parsing.
  \code{\link{same_family}}, \code{\link{compare_models}} and
  \code{\link{latest_model}} build on it.
}
\seealso{
  \url{https://whizi.io/models/} lists the real model names most of the
  test cases come from.
}
\examples{
parse_model("Qwen3.6 35B A3B")
}
