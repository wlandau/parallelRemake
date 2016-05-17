#' @title Function \code{run_if_outdated}
#' @description Runs R code in \code{expr} if any output files \code{out}
#' were created before any of the dependency files \code{dep} were created
#' or R packages \code{pkg} were last updated.
#' @details. If \code{out} is empty, \code{expr} does not run. If
#' \code{dep} is empty, then \code{expr} runs if and only if at least
#' one file given in \code{out} does not exist. If both \code{dep} and
#' \code{out} are nonempty and every element of \code{dep} is either
#' an existing file or an installed R package, \code{expr} will run 
#' if and only if at least one dependency was modified more recently 
#' than at least one output file.
#' @export
#' @param expr R expression with code to be evaluated.
#' @param dep Character vector. Elements are either paths to dependency
#' files or R packages. Dependency files get precedence, meaning that
#' the package \code{MASS} will checked only if the file \code{MASS} does 
#' not exist.
#' @param out Character vector of relative (or full) paths to output files saved
#' by the R code in \code{expr}.
run_if_outdated = function(expr, dep = NULL, out = NULL){
  if(!length(dep) & length(out)){
    if(any(!file.exists(out))) expr
  } else if (length(dep) & length(out)) {
    dep = unique(dep)
    out = unique(out)
    imiss = !file.exists(dep) & !(dep %in% installed.packages())
    miss = dep[imiss]
    miss = paste(miss, collapse = ", ")
    if(nchar(miss)) 
      stop(paste("the following are neither existing files nor installed R packages:", miss))
    dep_stamps = get_stamps_files(dep)
    notfile = !file.exists(dep)
    dep_stamps[notfile] = get_stamps_pkgs(dep[notfile])
    out_stamps = get_stamps_files(out)
    if(min(out_stamps) < max(dep_stamps)) expr
  }
}
