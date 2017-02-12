init_timestamps = function(remake_file = "remake.yml"){
  unlink(timestampdir, recursive = TRUE)
  dir.create(timestampdir)
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  targets = Filter(remake::is_current, remake::list_targets(remake_file))
  lapply(targets, function(x) 
    file.copy(".timestamp", timestamp(x), copy.date = TRUE))
  invisible()
}

timestampdir = ".data"

timestamp = function(x){
  file.path(timestampdir, x)
}

check_timestamps = function(){
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  lapply(list.files(timestampdir, full.names = TRUE), 
    function(x) stopifnot(file.mtime(".timestamp") == file.mtime(x)))
}
