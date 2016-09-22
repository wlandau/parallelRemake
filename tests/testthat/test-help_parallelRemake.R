# library(testthat); library(parallelRemake)
context("help_parallelRemake")

test_that("Function help_parallelRemake() runs correctly", {
  expect_output(help_parallelRemake())
})
