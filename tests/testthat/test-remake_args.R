# library(testthat); devtools::load_all(); 
context("remake_args")
source("utils.R")

test_that("Function remake_args behaves correctly.", {
  testwd("remake_args-ok")
  expect_equal(
    remake_args(list(hi = 1, remake_file = 12, target_names = 15, 
      x = 5, verbose = TRUE, file = "this file")),
    ", hi = 1, x = 5, verbose = TRUE, file = \"this file\"")
  expect_equal(remake_args(list(remake_file = 12, target_names = 15)), "")
  expect_equal(remake_args(list()), "")
  expect_error(remake_args(list(1, zero = 5)))
  expect_error(remake_args())
  expect_error(remake_args("file"))
  expect_error(remake_args("file1", "file2"))
  expect_error(remake_args(c("file1", "file2")))
  expect_error(remake_args(list("file")))
  expect_error(remake_args(list("file1", "file2")))
  testrm("remake_args-ok")
})

test_that("Correct Makefiles are made with remake_args.", {
  testwd("remake_args-Makefiles")
  example = "basic"
  example_parallelRemake(example)
  setwd(example)
  remake::make("clean")
  makefile(remake_args = list(verbose = F, string = "my string"), prepend = "#begin")
  expect_equal(readLines("Makefile")[-1], 
    readLines(file.path("..", "..", "test-remake_args", "Makefile"))[-1])
  expect_true(all(recallable() == c("mtcars", "random")))
  expect_equal(recall("mtcars"), mtcars)
  expect_equal(dim(recall("random")), c(32, 1))
  mtime = file.mtime("plot.pdf")
  Sys.sleep(1.1) # mtime resolutions are terrible on some OS's
  makefile(remake_args = list(verbose = F, string = "my string"), prepend = "#begin")
  expect_equal(mtime, file.mtime("plot.pdf"))
  setwd("..")
  unlink("basic", recursive = TRUE)
  testrm("remake_args-Makefiles")
})
