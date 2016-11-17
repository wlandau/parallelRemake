#' @title Function \code{example_parallelRemake}
#' @description Copy a parallelRemake example to the current working directory.
#' To see the names of all the examples, run \code{\link{list_examples_parallelRemake}}.
#' @seealso \code{\link{list_examples_parallelRemake}}, \code{\link{write_makefile}}
#' @export
#' @param example name of the example. To see all the available example names, 
#' run \code{\link{list_examples_parallelRemake}}.
example_parallelRemake = function(example = list_examples_parallelRemake()){
  example <- match.arg(example)
  dir <- system.file(file.path("examples", example), 
    package = "parallelRemake", mustWork = TRUE)
  if(file.exists(example)) 
    stop("There is already a file or folder named ", example, ".", sep = "")
  file.copy(from = dir, to = getwd(), recursive = TRUE)
  invisible()
}

#' @title Function \code{list_examples_parallelRemake}
#' @description Return the names of all the parallelRemake examples.
#' @seealso \code{\link{example_parallelRemake}}, \code{\link{write_makefile}}
#' @export
#' @return a names of all the parallelRemake examples.
list_examples_parallelRemake = function(){
  list.dirs(system.file("examples", package = "parallelRemake", mustWork = TRUE), 
    full.names = FALSE, recursive = FALSE)
}
