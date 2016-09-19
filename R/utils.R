#' @title Function \code{include_yaml}
#' @description Recursively find YAML files
#' @param remakefiles Character vector of remake files to add to the collation.
#' @param out Character vector of names of remakefiles to collate so far.
include_yaml = function(remakefiles, out = NULL){
  if(!length(remakefiles)) return(out)
  include = unlist(lapply(remakefiles, function(f) yaml_read(f)$include))
  out = c(out, remakefiles, include)
  unique(c(out, include_yaml(include, out)))
}

#' @title Function \code{remake_args}
#' @description Check additional arguments to \code{remake}.
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

#' @title Function \code{yaml_yesno_truefalse}
#' @description Turn yes/no values of a YAML file into TRUE/FALSE
#' @param file Character, name of \code{YAML} file to read
yaml_yesno_truefalse = function(file){
  y = readLines(file)
  for(s in c(":", "-")){
    y = gsub(paste0(s, "[ \t\r\v\f]*no[ \t\r\v\f]*$"), paste(s, "FALSE"), y)
    y = gsub(paste0(s, "[ \t\r\v\f]*yes[ \t\r\v\f]*$"), paste(s, "TRUE"), y)
  }
  write(y, file)
}
