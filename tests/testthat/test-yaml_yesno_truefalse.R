# library(testthat); library(parallelRemake);
context("yaml_yesno_truefalse")
source("utils.R")

test_that("Function yaml_yesno_truefalse is correct.", {
  testwd("yaml_yesno_truefalse-ok")
  for(i in 1:3){
    x = readLines(file.path("..", "test-yaml_yesno_truefalse", paste0("input", i, ".txt")))
    write(x, "out.txt")
    yaml_yesno_truefalse("out.txt")
    o1 = readLines("out.txt")
    o2 = readLines(file.path("..", "test-yaml_yesno_truefalse", paste0("output", i, ".txt")))
    expect_true(all(o1 == o2))
    unlink("out.txt")
  }
  testrm("yaml_yesno_truefalse-ok")
})
