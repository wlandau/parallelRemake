# library(testthat); library(parallelRemake); 
context("Example stages")
source("utils.R")
files = c("code.R", "remake.yml", "Makefile")
diri = function(i) paste0("stages-ok-", i)

test_that("Example stages happen correctly.", {
  testwd(diri(1))
  write_example_parallelRemake()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_false("Makefile" %in% list.files())
  testrm(diri(1))

  testwd(diri(2))
  setup_example_parallelRemake()
  expect_true("code.R" %in% list.files())
  expect_true("remake.yml" %in% list.files())
  expect_true("Makefile" %in% list.files())
  testrm(diri(2))
})
