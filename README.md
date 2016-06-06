This R package helps [`remake`](https://github.com/richfitz/remake) by adding parallelism. The function `write_makefile` creates a master [`Makefile`](https://www.gnu.org/software/make/) from an existing [`remake`](https://github.com/richfitz/remake)/[`YAML`](http://yaml.org/) file so that [`remake`](https://github.com/richfitz/remake) targets can be built in parallel with `make -j <n>`, where `<n>` is the number of parallel processes.

# Acknowledgements

This package stands on the shoulders of [Rich Fitzjohn](https://richfitz.github.io/)'s [`remake`](https://github.com/richfitz/remake) package, an understanding of which is a prerequisite for this one. Also thanks to [Daniel Falster](http://danielfalster.com/) for [the idea](https://github.com/richfitz/remake/issues/84) that cleaned everything up.

# Installation

Ensure that [R](https://www.r-project.org/) and [GNU make](https://www.gnu.org/software/make/) are installed, as well as the dependencies in the [`DESCRIPTION`](https://github.com/wlandau/parallelRemake/blob/master/DESCRIPTION). Open an R session and run 

```
library(devtools)
install_github("wlandau/parallelRemake")
```

Alternatively, you can build the package from the source and install it by hand. First, ensure that [git](https://git-scm.com/) is installed. Next, open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and enter the following commands.

```
git clone git@github.com:wlandau/parallelRemake.git
R CMD build parallelRemake
R CMD INSTALL ...
```

where `...` is replaced by the name of the tarball produced by `R CMD build`.

# Example

Use the `run_example` function to run the example workflow from start to finish. The steps are as follows.

1. Use the `example_source_file` function to create the example `code.R` with user-defined R code.
2. Use the `example_remake_file` function to create the example `remake.yml` file, which is [`remake`](https://github.com/richfitz/remake) code containing the user's workflow.
3. Use `write_makefile` to create the master [`Makefile`](https://www.gnu.org/software/make/) for running [`remake`](https://github.com/richfitz/remake) targets. The user will typically write `code.R` and `remake.yml` by hand and begin with this step.
4. Use [`Makefile`](https://www.gnu.org/software/make/) to run the workflow. Some example options are as follows.
    - `make` just runs the workflow in 1 process.
    - `make -j 4` distributes the workflow over at most 4 parallel processes.
    - `make clean` removes the files created by [`remake`](https://github.com/richfitz/remake)
    
# More on `write_makefile`

`write_makefile` has additional arguments. You can control the names of the [`Makefile`](https://www.gnu.org/software/make/) and the [`remake`](https://github.com/richfitz/remake)/[`YAML`](http://yaml.org/) file with the `makefile` and `remakefile` arguments, respectively. You can add lines to the beginning of the [`Makefile`](https://www.gnu.org/software/make/) with the `begin` argument, which could be useful for setting up the workflow for execution on a cluster, for example. You can append commands to `make clean` with the `clean` argument.


# A note on distributed computing

If you're running `make -j` over multiple nodes of a cluster, read this. [`remake`](https://github.com/richfitz/remake) uses a hidden folder called `.remake` in the current working directory for storing intermediate objects. You need to make sure that all the nodes share the same copy of `.remake` instead of creating their own local copies. That way, unnecessarily redundant rebuilds will be avoided. You could achieve this by using symbolic links, changing all nodes to the same working directory (`write_makefile(..., begin = "cd $PBS_O_WORKDIR")` for [PBS](https://en.wikipedia.org/wiki/Portable_Batch_System)), or some other method.
