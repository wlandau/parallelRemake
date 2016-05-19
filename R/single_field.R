#' @title Function \code{step}
#' @description Recursive function used by \code{step} to turn a list of fields 
#' into a \code{remake} YAML file.
#' @export
#' @seealso \code{one_process}
#' @param field a field or list of fields
#' @param name the name of the field
#' @param level level of recursion
single_field = function(field, name = "", level = 0){
  spaces = "  "
  indent = paste(rep(spaces, max(0, level - 1)), collapse = "")
  if(level) cat(indent, name, ": ", sep = "")
  if(is.list(field)){
    if(level) cat("\n")
    for(i in 1:length(field))
      single_field(field = field[[i]], name = names(field)[i], level = level + 1)
  } else if (is.character(field)){
    if(length(field) == 1){
      cat(field)
    } else {
      for(i in 1:length(field)) cat("\n", indent, spaces, "- ", field[i], sep = "")
    }
    cat("\n")
  }
  if(level > 0 & level < 3) cat("\n")
}