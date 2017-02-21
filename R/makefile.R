collate_remakefiles = function(remakefiles){
  remakefiles = unique(remakefiles)
  if(length(remakefiles) > 1 || length(yaml_read(remakefiles[1])$include) > 0){
    remakefile = collate_yaml(remakefiles)
  } else {
    remakefile = remakefiles
  }
  remakefile
}

makefile_rules = function(remakefile, make_these, targets, add_args){
  if(any(make_these == "all")) make_these = setdiff(names(targets), "all")
  make_these = unique(make_these)
  for(name in names(targets)){
    if(name == "all"){
      cat("all:", timestamp(make_these), "\n\n")
      next()
    }
    cat(timestamp(name), ": ", sep = "")
    target = targets[[name]]
    dep = unique(c(unlist(target$depends), parse_command(target$command)$depends))
    dep = dep[dep != "target_name"] # "target_name" is a keyword in remake.
    cat(timestamp(dep), "\n")
    if("command" %in% names(target) | !is.null(target$knitr)){
      cat("\tRscript -e \'if (!remake::is_current(\"",
          name, "\", remake_file = \"", remakefile, "\")) remake::make(\"", name, "\", remake_file = \"",
          remakefile, "\"", add_args, "); unlink(\"", 
          timestamp(name), "\"); invisible(file.create(\"", timestamp(name), "\"))\'\n", sep = "")
    }
    cat("\n")
  }
}

#' @title Function \code{makefile}
#' @description Writes an executes a Makefile to distribute \code{remake} targets
#' over simultaneous processes.
#' Use the \code{\link{help_parallelRemake}} function to get more help.
#' @details Use the \code{\link{help_parallelRemake}} function to get more help.
#' @seealso \code{\link{help_parallelRemake}}
#' @export
#' @param targets character vector of targets to make
#' @param remakefiles Character vector of paths to input \code{remake} files.
#' @param prepend Character vector of lines to prepend to the Makefile.
#' @param remake_args Named list of additional arguments to \code{remake::make}.
#' @param run logical, whether to actually run the Makefile or just write it.
#' @param command character scalar, command to run to execute the Makefile.
#' \code{command} and \code{args} will be used to call 
#' \code{system2(command = command, args = args)} to run the \code{Makefile}.
#' For example, to execute the \code{Makefile} using 4 parallel jobs
#' while suppressing output to the console, use 
#' \code{makefile(..., command = "make", args = c("--jobs=4", "-s"))}.
#' @param args character vector of arguments to the specified \code{command}.
#' \code{command} and \code{args} will be used to call
#' \code{system2(command = command, args = args)} to run the \code{Makefile}.
#' For example, to execute the \code{Makefile} using 4 parallel jobs
#' while suppressing output to the console, use
#' \code{makefile(..., command = "make", args = c("--jobs=4", "-s"))}.
makefile = function(targets = "all", remakefiles = "remake.yml", 
  prepend = NULL, remake_args = list(verbose = TRUE), run = TRUE,
  command = "make", args = character(0)){

  make_these = targets
  add_args = remake_args(remake_args)
  remakefile = collate_remakefiles(remakefiles)
  remake_data = yaml_read(remakefile)
  targets = remake_data$targets
  stopifnot(all(make_these %in% names(targets)))

  sink("Makefile")
  if(!is.null(prepend)) cat(prepend, "", sep = "\n")
  makefile_rules(remakefile, make_these, targets, add_args)
  sink()
  
  init_timestamps(names(targets), remakefile)
  if(run) system2(command = command, args = args)
  invisible()
}


#' @title DEPRECATED function \code{write_makefile}
#' @description See \code{\link{makefile}}. Makefiles are not standalone anymore.
#' You have to write and execute them in one step with \code{link{makefile}(..., run = TRUE)}.
#' Use the \code{\link{help_parallelRemake}} function to get more help.
#' @details Use the \code{\link{help_parallelRemake}} function to get more help.
#' @seealso \code{\link{makefile}}, \code{\link{help_parallelRemake}}
#' @export
#' @param targets See \code{\link{makefile}()}.
#' @param remakefiles See \code{\link{makefile}()}.
#' @param prepend See \code{\link{makefile}()}.
#' @param remake_args See \code{\link{makefile}()}.
#' @param run See \code{\link{makefile}()}.
#' @param command See \code{\link{makefile}()}.
#' @param args See \code{\link{makefile}()}.
write_makefile = function(targets = "all", remakefiles = "remake.yml", 
                    prepend = NULL, remake_args = list(verbose = TRUE), run = TRUE,
                    command = "make", args = character(0)){
  .Deprecated("makefile", package = "parallelRemake")
  stop("Do not use write_makefile() in version 1.0.0+ of parallelRemake. ",
    "Use makefile(..., run = TRUE) to both generate and run the Makefile in a single step. ",
    "Makefiles are not standalone anymore. You cannot run them outside of makefile(..., run = TRUE). ",
    "The reason is that parallelRemake is using dummy timestamp files to skip jobs that don't ",
    "Need to be submitted.")
}
