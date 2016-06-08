# library(testthat); library(parallelRemake); 
context("Example stages")
source("utils.R")
files = c("code.R", "remake.yml", "Makefile")

test_that("Example stages happen correctly.", {
  example_source_file()
  expect_true("code.R" %in% list.files())
  expect_false("remake.yml" %in% list.files())
  expect_false("Makefile" %in% list.files())
  cleanup(files)

  example_remake_file()
  expect_false("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_false("Makefile" %in% list.files())
  cleanup(files)

  write_example()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_false("Makefile" %in% list.files())
  cleanup(files)

  setup_example()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_true("Makefile" %in% list.files())
  cleanup(files)
})
