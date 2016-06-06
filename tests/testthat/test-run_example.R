# library(testthat); library(parallelRemake); 
source("cleanup.R")
source("output-run_example.R")

test_that("Example runs as expected", {
  data(mtcars)
  good_output = unlist(strsplit(good_output, "\n"))
  files = c("code.R", "data.csv", "Makefile", "plot1.pdf", "plot2.pdf", "remake.yml")
  out = run_example(T)
  expect_true(all(sort(out) == sort(good_output)))
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:2)))
  expect_true(all(recall("processed1")[,2:12] == mtcars))
  expect_true(all(recall("processed2")[,2:12] == mtcars))
  cleanup(files)
})
