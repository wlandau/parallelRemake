init_timestamps = function(targetnames, remakefile){
  unlink(timestampdir, recursive = TRUE)
  dir.create(timestampdir)
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  current = targetnames[remake::is_current(targetnames, remake_file = remakefile)]
  current_timestamps = timestamp(current)
  lapply(unique(dirname(current_timestamps)), dir.create, recursive = TRUE, showWarnings = FALSE)
  lapply(current_timestamps, file.copy, from = ".timestamp", copy.date = TRUE)
  unlink(".timestamp")
  invisible()
}

timestampdir = ".makefile"

timestamp = function(x){
  dirs = dirname(x)
  dirs = unique(dirs[dirs != "."])
  x = base64url::base64_urlencode(x)
  file.path(timestampdir, x)
}

un_timestamp = function(x){
  # Matches timestampdir at the beginning, plus one character (path separator)
  rx = utils::glob2rx(paste0(timestampdir, "?*"))
  gsub(rx, "", x) %>% base64url::base64_urldecode()
}

check_timestamps = function(){
  zip = system.file("timestamp.zip", package = "parallelRemake", mustWork = TRUE)
  unzip(zip, setTimes = TRUE)
  lapply(list.files(timestampdir, full.names = TRUE), 
    function(x) stopifnot(file.mtime(".timestamp") == file.mtime(x)))
}
