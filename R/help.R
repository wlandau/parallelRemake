#' @title Function \code{help_parallelRemake}
#' @description Prints links for tutorials, troubleshooting, bug reports, etc.
#' @seealso \code{\link{makefile}}
#' @export
help_parallelRemake = function(){
  cat(
#    "The package vignette has a full tutorial, and it is available at the following webpages.",
#    "    https://CRAN.R-project.org/package=parallelRemake/vignettes/parallelRemake.html",
#    "    https://cran.r-project.org/web/packages/parallelRemake/vignettes/parallelRemake.html",
    "The vignette of the development version has a full tutorial at the webpage below.",
    "    http://will-landau.com/parallelRemake/articles/parallelRemake.html",
    "For troubleshooting, navigate to the link below.",
    "    https://github.com/wlandau/parallelRemake/blob/master/TROUBLESHOOTING.md",
    "To submit bug reports, usage questions, feature requests, etc., navigate to the link below.",
    "    https://github.com/wlandau/parallelRemake/issues",
  sep = "\n")
}
