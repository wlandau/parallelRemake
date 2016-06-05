## COPIED FROM https://github.com/richfitz/remake utils.R and utils_assert.R.
## ALL CREDIT FOR THIS FILE GOES TO RICH FITZJOHN (https://richfitz.github.io/)

assert_file_exists <- function(x, name=deparse(substitute(x))) {
  if (!file.exists(x)) {
    stop(sprintf("The file '%s' does not exist", x), call.=FALSE)
  }
}

## Copied from RcppR6
read_file <- function(filename, ...) {
  assert_file_exists(filename)
  paste(readLines(filename), collapse="\n")
}

## https://github.com/viking/r-yaml/issues/5#issuecomment-16464325
yaml_load <- function(string) {
  ## More restrictive true/false handling.  Only accept if it maps to
  ## full true/false:
  handlers <- list("bool#yes" = function(x) {
    if (identical(toupper(x), "TRUE")) TRUE else x},
                   "bool#no" = function(x) {
    if (identical(toupper(x), "FALSE")) FALSE else x})
  yaml.load(string, handlers=handlers)
}


#' @title Function \code{yaml_read}
#' @description COPIED FROM https://github.com/richfitz/remake utils.R.
#' ALL CREDIT FOR THIS FILE GOES TO RICH FITZJOHN (https://richfitz.github.io/).
#' @export
#' @param filename Character, name of \code{YAML} file to read
yaml_read <- function(filename) {
  catch_yaml <- function(e) {
    stop(sprintf("while reading '%s'\n%s", filename, e$message),
         call.=FALSE)
  }
  tryCatch(yaml_load(read_file(filename)),
           error=catch_yaml)
}
