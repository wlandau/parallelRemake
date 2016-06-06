# library(testthat); library(parallelRemake); 
source("cleanup.R")

code = "generate_data = function(){\n  data(mtcars)\n  write.csv(mtcars, file = \"data.csv\")\n}\n\nprocess_data = function(filename){\n  d = read.csv(filename)\n  data.frame(x = d$mpg, y = d$cyl)\n}\n\nmyplot = function(data){\n  plot(y~x, data = data)\n}"

remake = "include: remake2.yml\n\nsources:\n  - code.R\n\ntargets:\n  all:\n    depends: \n      - plot1.pdf\n      - plot2.pdf\n      - plot3.pdf"

remake2 = "include:\n  - remake3.yml\n  - remake4.yml\n\ntargets:\n  plot1.pdf:\n    command: myplot(processed1)\n    plot: TRUE"

remake3 = "include: remake5.yml\n\ntargets:\n  processed1:\n    command: process_data(\"data.csv\")\n\n  processed2:\n    command: process_data(\"data.csv\")"

remake4 = "targets:\n  processed3:\n    command: process_data(\"data.csv\")"

remake5 = "targets:\n  plot2.pdf:\n    command: myplot(processed2)\n    plot: TRUE\n\n  plot3.pdf:\n    command: myplot(processed3)\n    plot: TRUE"

remake_data = "targets:\n  data.csv:\n    command: generate_data()"

files = c("code.R", "data.csv", "Makefile", paste0("plot", 1:3, ".pdf"),
            paste0("remake", c("", 2:5, "_data"), ".yml"), "collated_remake.yml")

collation = function(){
  any(grepl("collated", list.files()))
}

write_collation_files = function(){
  write(code, "code.R")
  write(remake, "remake.yml")
  write(remake2, "remake2.yml")
  write(remake3, "remake3.yml")
  write(remake4, "remake4.yml")
  write(remake5, "remake5.yml")
  write(remake_data, "remake_data.yml")
}

test_that("Collated workflow runs smoothly.", {
  good_output = "Rscript -e 'remake::make(\"data.csv\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > data.csv\n[ BUILD ] data.csv   |  generate_data()\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"processed1\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > processed1\n[    OK ] data.csv\n[ BUILD ] processed1 |  processed1 <- process_data(\"data.csv\")\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"plot1.pdf\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > plot1.pdf\n[    OK ] data.csv\n[    OK ] processed1\n[  PLOT ] plot1.pdf  |  myplot(processed1) # ==> plot1.pdf\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"processed2\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > processed2\n[    OK ] data.csv\n[ BUILD ] processed2 |  processed2 <- process_data(\"data.csv\")\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"plot2.pdf\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > plot2.pdf\n[    OK ] data.csv\n[    OK ] processed2\n[  PLOT ] plot2.pdf  |  myplot(processed2) # ==> plot2.pdf\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"processed3\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > processed3\n[    OK ] data.csv\n[ BUILD ] processed3 |  processed3 <- process_data(\"data.csv\")\n[  READ ]            |  # loading packages\nRscript -e 'remake::make(\"plot3.pdf\", remake_file = \"collated_remake.yml\")'\n[  LOAD ] \n[  READ ]            |  # loading sources\n<  MAKE > plot3.pdf\n[    OK ] data.csv\n[    OK ] processed3\n[  PLOT ] plot3.pdf  |  myplot(processed3) # ==> plot3.pdf\n[  READ ]            |  # loading packages"

  write_collation_files()
  write_makefile(remakefiles = c("remake.yml", "remake_data.yml"))
  expect_true(file.exists("collated_remake.yml"))
  out = system("make 2>&1", intern = T)
  expect_true(paste(out, collapse = "\n") == good_output)
  expect_true(all(files %in% list.files()))
  expect_true(all(recallable() == paste0("processed", 1:3)))
  cleanup(files)
})

test_that("Collation happens at the proper time.", {
  write_collation_files()
  write_makefile()
  expect_true(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = "remake3.yml")
  expect_true(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = "remake_data.yml")
  expect_false(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake_data.yml"))
  expect_false(collation())
  cleanup(files)

  write_collation_files()
  write_makefile(remakefiles = c("remake_data.yml", "remake5.yml"))
  expect_true(collation())
  cleanup(files)
})
