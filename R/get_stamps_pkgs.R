#' @title Function \code{get_stamps_pkgs}
#' @description Get "Packaged" dates of R pakcages in \code{pkgs}
#' @export
#' @param pkgs Character vector of package names.
get_stamps_pkgs = function(pkgs){
  unlist(sapply(pkgs, function(pkg){
    t = tryCatch(as.numeric(as.POSIXct(packageDescription(pkg, fields = "Packaged"))),
      error = function(e) -Inf, warning = function(w) -Inf)
  }))
}
