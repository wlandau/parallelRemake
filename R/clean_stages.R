check_stages = function(stages){
  if(!is.list(stages) | !length(stages)) stop("stages must be a nonempty list.")
  if(any(!nchar(names(stages)))) stop("names of stages list must all be nonempty.")
  if(anyDuplicated(unlist(stages))) 
    stop("elements within stages list must not have duplicate names.")
  if(anyDuplicated(names(stages))) stop("stages list must not have duplicate names.")
  if(anyDuplicated(c(names(stages), unlist(stages)))) 
    stop("stages list cannot share names with individual list elements.")
}
