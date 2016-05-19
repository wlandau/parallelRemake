#' @title Function \code{clean_stages}
#' @description Utility function to clean the \code{stages} argument to 
#' the function \code{remake2make}.
#' @seealso remake2make
#' @export
#' @param stages List of character vectors. Each character vector
#' is a subcollections of \code{remake} YAML files that can be run in parallel. 
#' The .yml extensions of the remake files are optional. For example, if I want to run 
#' remake1.yml and remake2.yml in parallel and then run finish.yml, I would specify
#'     stages = list(
#'       c("remake1.yml", "remake2.yml"),
#'       "finish.yml"
#'     )
#' 
#' or 
#' 
#'     stages = list(
#'       c("remake1", "remake2"),
#'       "finish"
#'     )
clean_stages = function(stages){
  if(is.null(names(stages))) names(stages) = paste0("stage", 1:length(stages))
  i = !nchar(names(stages))
  names(stages)[i] = paste0("unnamed_stage_", 1:sum(i))
  stages = lapply(stages, gsub, pattern = ".yml$", replacement = "")
  stages
}
