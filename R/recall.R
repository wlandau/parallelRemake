#' @title Function \code{recall}
#' @description Loads an object/target from the cache.
#' Use the \code{\link{parallelRemake_help}} function to get more help.
#' @details Use the \code{\link{parallelRemake_help}} function to get more help.
#' @seealso \code{\link{parallelRemake_help}}
#' @export
#' @return A loaded object
#' @param ... Characters, names of objects to load from cache
#' @param cache Character vector, path to \code{storr} cache to load from.
recall = function(..., cache = file.path(".remake", "objects")){
  if(!file.exists(cache)) stop(paste0("Remake cache \"", cache, "\" does not exist."))
  args = as.character(unlist(list(...)))
  st = storr_rds(cache)
  out = lapply(args, st$get)
  names(out) = args
  if(length(out) < 2) out = out[[1]]
  out
}

#' @title Function \code{recallable}
#' @description Lists the objects/targets available to laod from the cache.
#' Use the \code{\link{parallelRemake_help}} function to get more help.
#' @details Use the \code{\link{parallelRemake_help}} function to get more help.
#' @seealso \code{\link{parallelRemake_help}}
#' @export
#' @return A character vector of objects/targets available to laod from the cache.
#' @param cache Character vector, path to \code{storr} cache to load from.
recallable = function(cache = file.path(".remake", "objects")){
  if(!file.exists(cache)) return(character(0))
  st = storr_rds(cache)
  st$list()
}
