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
    x = readLines(file.path("..", "test-collation", file))
    write(x, file)
  }
}

diri = function(i) paste("collation-proper-time-", i)

test_that("Collated workflow runs smoothly.", {
  testwd("collation-ok")
  write_collation_files()
  write_makefile(remakefiles = c("remake.yml", "remake_data.yml"))
  expect_true(file.exists("collated_remake.yml"))
  system("make")
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:3)))
  testrm("collation-ok")
})

test_that("Collation happens at the proper time.", {
  dir = "collation-proper-time"
  testwd(diri(1))
  write_collation_files()
  write_makefile()
  expect_true(collation())
  testrm(diri(1))

  testwd(diri(2))
  write_collation_files()
  write_makefile(remakefiles = "remake3.yml")
  expect_true(collation())
  testrm(diri(2))

  testwd(diri(3))
  write_collation_files()
  write_makefile(remakefiles = "remake_data.yml")
  expect_false(collation())
  testrm(diri(3))

  testwd(diri(4))
  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake_data.yml"))
  expect_false(collation())
  testrm(diri(4))

  testwd(diri(5))
  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake5.yml"))
  expect_true(collation())
  testrm(diri(5))
})
