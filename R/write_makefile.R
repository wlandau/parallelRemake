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
          name, "\")) remake::make(\"", name, "\", remake_file = \"",
          remakefile, "\"", add_args, "); invisible(file.copy(\".timestamp\", \"", 
          timestamp(name), "\", copy.date = FALSE, overwrite = TRUE))\'\n", sep = "")
    }
    cat("\n")
  }
}

makefile_clean = function(remakefile, clean, add_args){
  cat("clean:\n\tRscript -e \'remake::make(\"clean\", remake_file = \"", 
      remakefile, "\"", add_args, ")\'\n", sep = "")
  cat("\trm -rf .data .remake .makefile\n")
  for(rule in clean) cat("\t", str_trim(rule), "\n", sep = "")
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
#' @param clean Character vector of commands to add to the \code{clean} rule.
#' @param remake_args Named list of additional arguments to \code{remake::make}.
#' @param run logical, whether to actually run the Makefile or just write it.
#' @param command character scalar, command to run to execute the Makefile
#' You cannot set \code{target_names} or \code{remake_file} this way because 
#' those names are already reserved.
makefile = function(targets = "all", remakefiles = "remake.yml", 
  prepend = NULL, clean = NULL, remake_args = list(), run = TRUE,
  command = "make"){

  make_these = targets
  add_args = remake_args(remake_args)
  remakefile = collate_remakefiles(remakefiles)
  remake_data = yaml_read(remakefile)
  targets = remake_data$targets
  stopifnot(all(make_these %in% names(targets)))

  sink("Makefile")
  if(!is.null(prepend)) cat(prepend, "", sep = "\n")
  makefile_rules(remakefile, make_these, targets, add_args)
  makefile_clean(remakefile, clean, add_args)
  sink()
  
  init_timestamps(names(targets))
  if(run) system(command)
  invisible()
}
