IO = "io/"

cleanup = function(files){
  unlink(".remake", recursive = T)
  unlink("*.yml")
  for(f in files) unlink(f)
}
