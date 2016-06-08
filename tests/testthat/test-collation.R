# library(testthat); library(parallelRemake); 
context("Collation")
source("utils.R")

files = c("code.R", "data.csv", "Makefile", paste0("plot", 1:3, ".pdf"),
            paste0("remake", c("", 2:5, "_data"), ".yml"), "collated_remake.yml")

collation = function(){
  any(grepl("collated", list.files()))
}

write_collation_files = function(){
  for(file in c("code.R", paste0("remake", c("", 2:5, "_data"), ".yml"))){
    x = readLines(paste0("test-collation/", file))
    write(x, file)
  }
}

test_that("Collated workflow runs smoothly.", {
  write_collation_files()
  write_makefile(remakefiles = c("remake.yml", "remake_data.yml"))
  expect_true(file.exists("collated_remake.yml"))
  out = system("make 2>&1", intern = T)
  good_output = readLines("test-collation/output.txt")
  expect_true(all(out == good_output))
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
