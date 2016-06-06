# library(testthat); library(parallelRemake); 
source("cleanup.R")
source("files-collation.R")
source("output-collation.R")

files = c("code.R", "data.csv", "Makefile", paste0("plot", 1:3, ".pdf"),
            paste0("remake", c("", 2:5, "_data"), ".yml"), "collated_remake.yml")

collation = function(){
  any(grepl("collated", list.files()))
}

write_collation_files = function(){
  write(code, "code.R")
  write(remake, "remake.yml")
  write(remake2, "remake2.yml")
  write(remake3, "remake3.yml")
  write(remake4, "remake4.yml")
  write(remake5, "remake5.yml")
  write(remake_data, "remake_data.yml")
}

test_that("Collated workflow runs smoothly.", {
  write_collation_files()
  write_makefile(remakefiles = c("remake.yml", "remake_data.yml"))
  expect_true(file.exists("collated_remake.yml"))
  out = system("make 2>&1", intern = T)
  expect_true(paste(out, collapse = "\n") == good_output)
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:3)))
  cleanup(files)
})

test_that("Collation happens at the proper time.", {
  write_collation_files()
  write_makefile()
  expect_true(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = "remake3.yml")
  expect_true(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = "remake_data.yml")
  expect_false(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake_data.yml"))
  expect_false(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake5.yml"))
  expect_true(collation())
  cleanup(files)
})
