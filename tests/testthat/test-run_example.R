# library(testthat); library(parallelRemake); 
source("cleanup.R")

test_that("Example runs as expected", {
  good_output = "<  MAKE > data.csv\n<  MAKE > plot1.pdf\n<  MAKE > plot2.pdf\n<  MAKE > processed1\n<  MAKE > processed2\nRscript -e 'remake::make(\"data.csv\", remake_file = \"remake.yml\")'\nRscript -e 'remake::make(\"plot1.pdf\", remake_file = \"remake.yml\")'\nRscript -e 'remake::make(\"plot2.pdf\", remake_file = \"remake.yml\")'\nRscript -e 'remake::make(\"processed1\", remake_file = \"remake.yml\")'\nRscript -e 'remake::make(\"processed2\", remake_file = \"remake.yml\")'\n[    OK ] data.csv\n[    OK ] data.csv\n[    OK ] data.csv\n[    OK ] data.csv\n[    OK ] processed1\n[    OK ] processed2\n[  LOAD ] \n[  LOAD ] \n[  LOAD ] \n[  LOAD ] \n[  LOAD ] \n[  PLOT ] plot1.pdf  |  myplot(processed1) # ==> plot1.pdf\n[  PLOT ] plot2.pdf  |  myplot(processed2) # ==> plot2.pdf\n[  READ ]            |  # loading packages\n[  READ ]            |  # loading packages\n[  READ ]            |  # loading packages\n[  READ ]            |  # loading packages\n[  READ ]            |  # loading packages\n[  READ ]            |  # loading sources\n[  READ ]            |  # loading sources\n[  READ ]            |  # loading sources\n[  READ ]            |  # loading sources\n[  READ ]            |  # loading sources\n[ BUILD ] data.csv   |  download_data()\n[ BUILD ] processed1 |  processed1 <- process_data(\"data.csv\")\n[ BUILD ] processed2 |  processed2 <- process_data(\"data.csv\")"
  good_output = unlist(strsplit(good_output, "\n"))

  data(mtcars)
  files = c("code.R", "data.csv", "Makefile", "plot1.pdf", "plot2.pdf", "remake.yml")
  out = run_example(T)
  expect_true(all(sort(out) == sort(good_output)))
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:2)))
  expect_true(all(recall("processed1")[,2:12] == mtcars))
  expect_true(all(recall("processed2")[,2:12] == mtcars))
  cleanup(files)
})
