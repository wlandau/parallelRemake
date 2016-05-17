#' @title Function \code{get_stamps_files}
#' @description Get timestamps of \code{files}
#' @export
#' @param files File paths (full or relative) of files to get timestamps.
get_stamps_files = function(files){
  unlist(sapply(files, function(f){
    x = file.mtime(f)
    x = as.numeric(x)
    ifelse(is.na(x), -Inf, x)
  }))
}
