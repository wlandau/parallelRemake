library(testthat)
library(parallelRemake)

Sys.setenv("R_TESTS" = "")
test_check("parallelRemake")
