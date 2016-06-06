## COPIED FROM https://github.com/richfitz/remake utils.R and utils_assert.R.
## ALL CREDIT FOR THIS FILE GOES TO RICH FITZJOHN (https://richfitz.github.io/)

assert_character <- function(x, name=deparse(substitute(x))) {
  if (!is.character(x)) {
    stop(sprintf("%s must be character", name), call.=FALSE)
  }
}

assert_file_exists <- function(x, name=deparse(substitute(x))) {
  if (!file.exists(x)) {
    stop(sprintf("The file '%s' does not exist", x), call.=FALSE)
  }
}

assert_scalar <- function(x, name=deparse(substitute(x))) {
  if (length(x) != 1) {
    stop(sprintf("%s must be a scalar", name), call.=FALSE)
  }
}

assert_scalar_character <- function(x, name=deparse(substitute(x))) {
  assert_scalar(x, name)
  assert_character(x, name)
}

file_extension <- function(x) {
  pos <- regexpr("\\.([^.]+)$", x, perl=TRUE)
  ret <- rep_along("", length(x))
  i <- pos > -1L
  ret[i] <- substring(x[i], pos[i] + 1L)
  ret
}

from_yaml_map_list <- function(x) {
  if (length(x) == 0L || is.character(x)) {
    x <- as.list(x)
  } else if (is.list(x)) {
    if (!all(viapply(x, length) == 1L)) {
      stop("Expected all elements to be scalar")
    }
    x <- unlist(x, FALSE)
  } else {
    stop("Unexpected input")
  }
  x
}

## Copied from RcppR6
read_file <- function(filename, ...) {
  assert_file_exists(filename)
  paste(readLines(filename), collapse="\n")
}

rep_along <- function(x, along.with) {
  rep_len(x, length(along.with))
}

vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}

viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}

vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
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
