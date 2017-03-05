testwd = function(x){
  dir = paste0("RUN-", x)
  if(file.exists(file.path("..", dir))) return()
  if(!file.exists(dir)) dir.create(dir)
  setwd(dir)
}

testrm = function(x){
  dir = paste0("RUN-", x)
  if(!file.exists(file.path("..", dir))) return()
  setwd("..")
  unlink(dir, recursive = T)
}
