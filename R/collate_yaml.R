#' @title Function \code{collate_yaml}
#' @description Collate interdependent remake/YAML files into a single 
#' master remake/YAML file. Files in the "include:" fields will be collated
#' as well
#' @export
#' @param remakefiles Character vector of the paths to the remake/YAML
#' files to collate. 
#' @param collated name of collated remake/YAML file.
collate_yaml = function(remakefiles = "remake.yml", collated = paste0("collated_", remakefiles[1])){
  files = include_yaml(remakefiles)
  contents = lapply(files, yaml_read)
  fields = unique(unlist(lapply(contents, names)))
  out = list()
  for(f in fields)
    out[[f]] = do.call(c, lapply(contents, function(x) x[[f]]))
  out = out[names(out) != "include"]
  write(as.yaml(out), collated)
  yaml_yesno_truefalse(collated)
  collated
}
