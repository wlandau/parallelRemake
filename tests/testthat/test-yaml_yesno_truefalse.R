# library(testthat); library(parallelRemake);
context("yaml_yesno_truefalse")
source("utils.R")

test_that("Function yaml_yesno_truefalse is correct.", {
  for(i in 1:3){
    x = readLines(paste0("test-yaml_yesno_truefalse/input", i, ".txt"))
    write(x, "out.txt")
    yaml_yesno_truefalse("out.txt")
    o1 = readLines("out.txt")
    o2 = readLines(paste0("test-yaml_yesno_truefalse/output", i, ".txt"))
    expect_true(all(o1 == o2))
    unlink("out.txt")
  }
})
