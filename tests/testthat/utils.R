testwd = function(x){
  dir = paste0("RUN-", x)
  if(!file.exists(dir)) dir.create(dir)
  setwd(dir)
}

testrm = function(){
  d1 = getwd()
  setwd("..")
  d2 = getwd()
  d = gsub(d2, "", d1)
  d = gsub("[^[:alnum:]|_|-]", "", d)
  unlink(d, recursive = T)
}
