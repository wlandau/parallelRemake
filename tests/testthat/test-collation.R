# library(testthat); devtools::load_all(); 
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
  makefile(remakefiles = c("remake.yml", "remake_data.yml"), remake_args = list(verbose = F))
  expect_true(file.exists("collated_remake.yml"))
  expect_identical(recallable(), c("data", paste0("processed", 1:3)))
  testrm("collation-ok")
})

test_that("Collation happens at the proper time.", {
  dir = "collation-proper-time"
  testwd(diri(1))
  write_collation_files()
  makefile(run = F, remakefiles = c("remake.yml", "remake_data.yml"))
  expect_true(collation())
  testrm(diri(1))

  testwd(diri(2))
  write_collation_files()
  makefile(targets = "data", remakefiles = "remake_data.yml", run = F)
  expect_false(collation())
  testrm(diri(2))
})
