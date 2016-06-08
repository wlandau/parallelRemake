# library(testthat); library(parallelRemake); 
context("run_example")
source("utils.R")

test_that("Example runs as expected", {
  data(mtcars)
  files = c("code.R", "data.csv", "Makefile", "plot1.pdf", "plot2.pdf", "remake.yml")
  out = run_example(T)
  good_output = readLines(paste0(IO, "output-run_example.txt"))
  expect_true(all(sort(out) == sort(good_output)))
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:2)))
  expect_true(all(recall("processed1")[,2:12] == mtcars))
  expect_true(all(recall("processed2")[,2:12] == mtcars))
  expect_true(file.exists(".remake"))
  out = system("make clean 2>&1", intern = T)
  expect_false(file.exists(".remake"))
  cleanup(files)
})
