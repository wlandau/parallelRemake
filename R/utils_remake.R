## THIS FILE WAS COPIED AND SLIGHTLY MODIFIED FROM 
## FILES IN https://github.com/richfitz/remake/R
## (parse_command.R, utils.R, and utils_assert.R).
## RICH FITZJOHN (https://richfitz.github.io/) OWNS COPYRIGHT
## FOR ALL THE FUNCTIONS IN THIS FILE. ALL RIGHTS RESERVED.

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

check_command <- function(str) {
  if (is.language(str)) {
    command <- str
  } else {
    assert_scalar_character(str)
    command <- parse(text=as.character(str), keep.source=FALSE)
    if (length(command) != 1L) {
      stop("Expected single expression")
    }
    command <- command[[1]]
  }
  if (!is.call(command)) {
    stop("Expected a function call (even with no arguments)")
  }
  command
}

check_command_rule <- function(x) {
  if (is.name(x)) {
    x <- as.character(x)
  } else if (!is.character(x)) {
    stop("Rule must be a character or name")
  }
  x
}

check_literal_arg <- function(x) {
  if (is.atomic(x)) { # logical, integer, complex types
    x
  } else if (is.call(x)) {
    if (identical(x[[1]], quote(I))) {
      x[[2]]
    } else {
      ## This error message is not going to be useful:
      stop("Unknown special function ", as.character(x[[1]]))
    }
  } else {
    stop("Unknown type in argument list")
  }
}

is_target_like <- function(x) {
  is.character(x) || is.name(x)
}

parse_command <- function(str) {
  if(is.null(str)) return()
  command <- check_command(str)

  rule <- check_command_rule(command[[1]])

  ## First, test for target-like-ness.  That will be things that are
  ## names or character only.  Numbers, etc will drop through here:
  is_target <- unname(vlapply(command[-1], is_target_like))

  ## ...and we check them and I() arguments here:
  if (any(!is_target)) {
    i <- c(FALSE, !is_target)
    command[i] <- lapply(command[i], check_literal_arg)
  }

  ## TODO: DEPENDS: Who actually uses args, given it's defined so simply?
  args <- as.list(command[-1])
  depends <- vcapply(args[is_target], as.character)

  list(rule=rule, args=args, depends=depends, is_target=is_target,
       command=command)
}

## Copied from RcppR6
read_file <- function(filename, ...) {
  assert_file_exists(filename)
  paste(readLines(filename), collapse="\n")
}

vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
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

yaml_read <- function(filename) {
  catch_yaml <- function(e) {
    stop(sprintf("while reading '%s'\n%s", filename, e$message),
         call.=FALSE)
  }
  tryCatch(yaml_load(read_file(filename)),
           error=catch_yaml)
}
