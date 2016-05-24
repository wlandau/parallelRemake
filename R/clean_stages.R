check_stages = function(stages){
  if(!is.list(stages) | !length(stages)) stop("stages must be a nonempty list.")
  if(any(!nchar(names(stages)))) stop("each element of names(stages) must be nonempty.")
  if(anyDuplicated(unlist(stages))) 
    stop("No duplicates allowed in unlist(stages) after .yml extensions are removed.")
  if(anyDuplicated(names(stages))) stop("No duplicates allowed in names(stages).")
  if(anyDuplicated(c(names(stages), unlist(stages)))) 
    stop("No duplicates allowed in c(names(stages), unlist(stages)) after .yml extensions are removed..")
}
