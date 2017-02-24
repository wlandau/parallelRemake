init_timestamps = function(targetnames, remakefile){
  unlink(timestampdir, recursive = TRUE)
  dir.create(timestampdir)
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  current = targetnames[remake::is_current(targetnames, remake_file = remakefile)]
  lapply(current, function(x) 
    file.copy(".timestamp", timestamp(x), copy.date = TRUE))
  unlink(".timestamp")
  invisible()
}

timestampdir = ".makefile"

timestamp = function(x){
  file.path(timestampdir, x)
}

un_timestamp = function(x){
  # Matches timestampdir at the beginning, plus one character (path separator)
  rx = utils::glob2rx(paste0(timestampdir, "?*"))
  gsub(rx, "", x)
}

check_timestamps = function(){
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  lapply(list.files(timestampdir, full.names = TRUE), 
    function(x) stopifnot(file.mtime(".timestamp") == file.mtime(x)))
}
