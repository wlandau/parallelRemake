# library(testthat); library(parallelRemake); 
context("Example stages")
source("utils.R")
files = c("code.R", "remake.yml", "Makefile")

test_that("Example stages happen correctly.", {
  write_example_parallelRemake()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_false("Makefile" %in% list.files())
  cleanup(files)

  setup_example_parallelRemake()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_true("Makefile" %in% list.files())
  cleanup(files)
})
