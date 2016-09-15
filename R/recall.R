#' @title Function \code{recall}
#' @description Load an intermediate object previously generated in the workflow.
#' This could be a dataset, analysis, etc.
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
#' @description List the items available to laod from the cache.
#' @export
#' @return A loaded object
#' @param cache Character vector, path to \code{storr} cache to load from.
recallable = function(cache = file.path(".remake", "objects")){
  if(!file.exists(cache)) return(character(0))
  st = storr_rds(cache)
  st$list()
}
