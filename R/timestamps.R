init_timestamps = function(targetnames){
  unlink(timestampdir, recursive = TRUE)
  dir.create(timestampdir)
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  targets = Filter(remake::is_current, targetnames)
  lapply(targets, function(x) 
    file.copy(".timestamp", timestamp(x), copy.date = TRUE))
  unlink(".timestamp")
  invisible()
}

timestampdir = ".makefile"

timestamp = function(x){
  file.path(timestampdir, x)
}

check_timestamps = function(){
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  lapply(list.files(timestampdir, full.names = TRUE), 
    function(x) stopifnot(file.mtime(".timestamp") == file.mtime(x)))
}
