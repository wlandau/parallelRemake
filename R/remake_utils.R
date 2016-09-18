## THIS FILE WAS COPIED AND MODIFIED FROM 
## https://github.com/richfitz/remake utils.R and utils_assert.R.
## ALL FUNCTIONS WITHOUT ROXYGEN COMMENTS WERE WRITTEN BY
## RICH FITZJOHN (https://richfitz.github.io/). THE yaml_read
## FUNCTION WAS ALSO WRITTEN BY RICH FITZJOHN.
## 
## LICENSE: https://raw.githubusercontent.com/richfitz/remake/master/LICENSE
##
## The BSD 2-Clause License
##
## Copyright (c) 2014, Rich FitzJohn 
## (http://richfitz.github.io/, ## https://github.com/richfitz)
## All rights reserved.
## 
## Redistribution and use in source and binary forms, with or 
## without modification, are permitted provided that the following 
## conditions are met:
## 
## 1. Redistributions of source code must retain the above 
## copyright notice, this list of conditions and the following 
## disclaimer.
## 
## 2. Redistributions in binary form must reproduce the above 
## copyright notice, this list of conditions and the following 
## disclaimer in the documentation and/or other materials provided 
## with the distribution.
## 
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
## CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
## INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
## DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
## CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
## NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
## HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
## OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

#' @title Function \code{include_yaml}
#' @description Recursively find YAML files
#' @export
#' @param remakefiles Character vector of remake files to add to the collation.
#' @param out Character vector of names of remakefiles to collate so far.
include_yaml = function(remakefiles, out = NULL){
  if(!length(remakefiles)) return(out)
  include = unlist(lapply(remakefiles, function(f) yaml_read(f)$include))
  out = c(out, remakefiles, include)
  unique(c(out, include_yaml(include, out)))
}

## Copied from RcppR6
read_file <- function(filename, ...) {
  assert_file_exists(filename)
  paste(readLines(filename), collapse="\n")
}

#' @title Function \code{remake_args}
#' @description Check additional arguments to \code{remake}.
#' @export
#' @param x List of arguments to remake. Must be named.
remake_args = function(x){
  if(!length(x)) return("")
  lack_names = !length(names(x)) | any(!nchar(names(x)))
  if(lack_names) stop("All additional arguments to remake::make must have names.")
  x = x[!(names(x) %in% c("target_names", "remake_file"))]
  if(!length(x)) return("")
  x = lapply(x, function(i){
    if(is.character(i)) i = paste0("\"", i, "\"")
    i
  })
  x = lapply(x, as.character)
  x = paste(names(x), "=", x)
  x = paste(x, collapse = ", ")
  paste(",", x)
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
#' @details LICENSE: https://raw.githubusercontent.com/richfitz/remake/master/LICENSE
#'
#' The BSD 2-Clause License
#' 
#' Copyright (c) 2014, Rich FitzJohn 
#' (http://richfitz.github.io/, #' https://github.com/richfitz)
#' All rights reserved.
#' 
#' Redistribution and use in source and binary forms, with or 
#' without modification, are permitted provided that the following 
#' conditions are met:
#' 
#' 1. Redistributions of source code must retain the above 
#' copyright notice, this list of conditions and the following 
#' disclaimer.
#' 
#' 2. Redistributions in binary form must reproduce the above 
#' copyright notice, this list of conditions and the following 
#' disclaimer in the documentation and/or other materials provided 
#' with the distribution.
#' 
#' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
#' CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
#' INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
#' MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
#' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
#' CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
#' SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
#' NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
#' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
#' HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
#' CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
#' OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
#' EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
yaml_read <- function(filename) {
  catch_yaml <- function(e) {
    stop(sprintf("while reading '%s'\n%s", filename, e$message),
         call.=FALSE)
  }
  tryCatch(yaml_load(read_file(filename)),
           error=catch_yaml)
}

#' @title Function \code{yaml_yesno_truefalse}
#' @description Turn yes/no values of a YAML file into TRUE/FALSE
#' @export
#' @param file Character, name of \code{YAML} file to read
yaml_yesno_truefalse = function(file){
  y = readLines(file)
  for(s in c(":", "-")){
    y = gsub(paste0(s, "[ \t\r\v\f]*no[ \t\r\v\f]*$"), paste(s, "FALSE"), y)
    y = gsub(paste0(s, "[ \t\r\v\f]*yes[ \t\r\v\f]*$"), paste(s, "TRUE"), y)
  }
  write(y, file)
}
