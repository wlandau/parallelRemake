This package is designed to help with large reproducible R workflows. The main use of this package is to do what Makefiles do: namely, provide a way to compute output only if dependencies have changed. But unlike Makefiles, this package provides a way to weave output-generation rules directly alongside the respective blocks of R code without needing to maintain an overall Makefile. In addition, future versions of this package will integrate with workflows implemented as separate R packages, so that output generation responds intelligently to package updates.

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

Similar to Makefiles, the function `run_if_outdated(expr, dep, out)` runs the R code in `expr` if the dependency files and installed packages listed in `dep` exist and any were modified prior to the files listed in `out`. In the future, this function will optionally factor in timestamps of individual components of packages that use `workflowHelper`. That way, workflows implemented as packages can still generate all required output while avoiding redundant work. Here are some examples.

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