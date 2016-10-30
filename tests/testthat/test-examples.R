# library(testthat); library(parallelRemake); 
context("Example stages")
source("utils.R")
files = c("code.R", "remake.yml", "Makefile")

test_that("Stages in basic example happen correctly.", {
  testwd("examples")
  example = "basic"
  expect_silent(example_parallelRemake(example))
  expect_error(example_parallelRemake(example))
  expect_error(example_parallelRemake("asldasdflkklsdfjlkfjaljsdfpiojallksdkf"))
  setwd(example)
  for(f in c("code.R", "remake.yml")) expect_true(f %in% list.files())
  write_makefile(remakefiles = "remake.yml")
  for(f in files) expect_true(f %in% list.files())
  system("make mtcars")
  system("make -j 2")
  system("make clean")
  setwd("..")
  unlink(example, recursive = TRUE)
  testrm("examples")
})
