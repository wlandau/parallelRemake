# library(testthat); library(parallelRemake)
context("parallelRemake_help")

test_that("Function parallelRemake_help() runs correctly", {
  expect_output(parallelRemake_help())
})
