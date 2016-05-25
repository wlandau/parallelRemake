#' @title Function \code{strings}
#' @description Turns expressions into character strings
#' @export
#' @return a named character vector
#' @param ... list of expressions to turn into character strings
strings = function(...) {
  args = structure(as.list(match.call()[-1]), class = "uneval")
  keys = names(args)
  out = as.character(args)
  names(out) = keys
  out
}
