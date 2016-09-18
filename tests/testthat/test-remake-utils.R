# library(testthat); library(parallelRemake); 
context("remake utils")

test_that("remake utils throw the right errors.", {
  expect_null(assert_character("char"))
  expect_error(assert_character(1))
  expect_error(assert_file_exists("2983749"))
  expect_null(assert_scalar(1))
  expect_error(assert_scalar(1:2))
  expect_equal(call("f"), check_command("f()"))
  expect_error(check_command(expression(1)))
  expect_error(check_command("x <- 1; y <- 2"))
  expect_equal("cmd", check_command_rule("cmd"))
  expect_error(check_command_rule(1))
  expect_equal(1, check_literal_arg(1))
  expect_equal("file", check_literal_arg(call("I", "file")))
  expect_error(check_literal_arg(call("round", 10.5)))
  expect_error(check_literal_arg(list()))
  expect_equal(parse_command("f(I(\"arg\"))"), list(
    rule = "f",
    args = list("arg"),
    depends = character(0),
    is_target = FALSE,
    command = call("f", "arg")
  ))
  expect_equal(yaml_load("target: TRUE"), list(target = TRUE))
  expect_equal(yaml_load("target: FALSE"), list(target = FALSE))
  expect_error(yaml_read("29878476"))
})
