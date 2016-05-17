This package is designed to help with reproducible R workflows.

# Installation

Open an R session and run 

```
library(devtools)
install_github("wlandau/workflowHelper")
```

Alternatively, you can build the package from the source and install it by hand.

Open a command line program such as Terminal in Mac/Linux and enter the following commands.

```
git clone git@github.com:wlandau/workflowHelper.git
R CMD build workflowHelper
R CMD INSTALL ...
```

where `...` is replaced by the name of the tarball produced by `R CMD build`. 


# Function `run_if_outdated(expr, dep, out)`

Similar to Makefiles, the funciton `run_if_outdated(expr, dep, out)` runs the R code in `expr` if the dependency files and installed packages listed in `dep` exist and were modified prior to the files in `out`. In the future, this function will factor in timestamps of individual components of packages that depends on `workflowHelper`. Here are some examples.

```
library(workflowHelper)

run_if_outdated(
  expr = print("Does not run.")
)

run_if_outdated(
  expr = print("Does not run."),
  dep = "dep1"
)

run_if_outdated(
  expr = print("Throws an error."),
  dep = "dep1",
  out = "out1"
)

file.create("dep1")

run_if_outdated(
  expr = {
    file.create("out1")
    print("Does run.")
  },
  dep = c("MASS", "dep1"),
  out = "out1"
)

run_if_outdated(
  {
    file.create("out1")
    print("Does not run.")
  },
  dep = c("MASS", "dep1"),
  out = "out1"
)

```