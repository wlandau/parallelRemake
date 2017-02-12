# library(testthat); library(parallelRemake); 
context("Timestamps")
source("utils.R")

test_that("Timestamp files are written without mangling the dates.", {
  testwd("timestamps")
  example = "basic"
  expect_silent(example_parallelRemake(example))
  setwd(example)
  expect_silent(init_timestamps())
  expect_silent(check_timestamps())
  setwd("..")
  unlink(example, recursive = TRUE)
  testrm("examples")
})
