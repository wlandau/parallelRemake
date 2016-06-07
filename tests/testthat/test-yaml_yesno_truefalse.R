# library(testthat); library(parallelRemake);
context("yaml_yesno_truefalse")
source("utils.R")

test_that("Function yaml_yesno_truefalse is correct.", {
  for(i in 1:2){
    x = readLines(paste0(IO, "in", i, "-yaml_yesno_truefalse.txt"))
    write(x, "out.txt")
    yaml_yesno_truefalse("out.txt")
    o1 = readLines("out.txt")
    o2 = readLines(paste0(IO, "out", i, "-yaml_yesno_truefalse.txt"))
    expect_true(all(o1 == o2))
    unlink("out.txt")
  }
})
