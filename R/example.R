#' @title Function \code{example_source_file}
#' @description Write the R code file for the example to \code{code.R}
#' @export
example_source_file = function(){
  write("download_data = function(){\n  data(mtcars)\n# mtcars$mpg = mtcars$mpg + 1 # TOGGLE THIS LINE TO FORCE A REBUILD\n  write.csv(mtcars, \"data.csv\")\n}\n\nprocess_data = function(file){\n  read.csv(file)\n}\n\nmyplot = function(d){\n  plot(cyl ~ mpg, data = d)\n}", file = "code.R")
}

#' @title Function \code{example_remake_file}
#' @description Write the example \code{remake} file \code{remake.yml}.
#' @export
example_remake_file = function(){
  write("sources:\n  - code.R\n\ntargets:\n  all:\n    depends: \n      - plot1.pdf\n      - plot2.pdf\n\n  data.csv:\n    command: download_data()\n\n  processed1:\n    command: process_data(\"data.csv\")\n\n  processed2:\n    command: process_data(\"data.csv\")\n\n  plot1.pdf:\n    command: myplot(processed1)\n    plot: true\n\n  plot2.pdf:\n    command: myplot(processed2)\n    plot: true", file = "remake.yml")
}

#' @title Function \code{run_example}
#' @description Run the whole example: generate the \code{remake} file,
#' then generate the master \code{Makefile} to run the targets in parallel,
#' and then run \code{make} to run the workflow in parallel.
#' @export
#' @param intern Argument to system, option to capture output.
run_example = function(intern = F){
  example_source_file()
  example_remake_file()
  write_makefile()
  system("make -j 4 2>&1", intern = intern)
}
