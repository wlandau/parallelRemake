This R package can help you to maintain a large project. Thanks to [`remake`](https://github.com/richfitz/remake), your project is kept up to date as efficiently as possible: whenever you change a function in your custom code (or any other dependency), only the affected pieces of your workflow will be recomputed. This is similar to how [GNU make](https://www.gnu.org/software/make/) works. What this package adds is parallel computing, something that [`remake`](https://github.com/richfitz/remake) does not implement yet. The function `write_makefile` creates a master [`Makefile`](https://www.gnu.org/software/make/) from an existing [`remake`](https://github.com/richfitz/remake)/[`YAML`](http://yaml.org/) file so that [`remake`](https://github.com/richfitz/remake) targets can be built in parallel with `make -j <n>`, where `<n>` is the number of parallel processes.



# Acknowledgements

This package stands on the shoulders of [Rich FitzJohn](https://richfitz.github.io/)'s [`remake`](https://github.com/richfitz/remake) package, an understanding of which is a prerequisite for this one. Also thanks to [Daniel Falster](http://danielfalster.com/) for [the idea](https://github.com/richfitz/remake/issues/84) that cleaned everything up.

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

## Windows users need [`Rtools`](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows).

The example and tests sometimes use `system("make")` and similar commands. So if you're using the Windows operating system, you will need to install the [`Rtools`](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows) package.

# Example

Use the `run_example_parallelRemake` function to run the example workflow from start to finish. The steps are as follows.

1. Use the `write_example_parallelRemake` function to create `code.R` with example user-defined R code `remake.yml` file with the [`remake`](https://github.com/richfitz/remake) instructions to direct the workflow. The `write_example_parallelRemake` function does steps 1 and 2.
2. Use `write_makefile` to create the master [`Makefile`](https://www.gnu.org/software/make/) for running [`remake`](https://github.com/richfitz/remake) targets. The user will typically write `code.R` and `remake.yml` by hand and begin with this step. The `setup_example_parallelRemake` function does steps 1 and 2.
3. Use [`Makefile`](https://www.gnu.org/software/make/) to run the workflow. The `run_example_parallelRemake` function does steps 1 through 3. Some example options are as follows.
    - `make` just runs the workflow in 1 process.
    - `make -j 4` distributes the workflow over at most 4 parallel processes.
    - `make clean` removes the files created by [`remake`](https://github.com/richfitz/remake).
5. Optionally, use the `clean_example_parallelRemake` function to remove all the files generated in steps 1 through 4.
    
# More on `write_makefile`

`write_makefile` has additional arguments. You can control the names of the [`Makefile`](https://www.gnu.org/software/make/) and the [`remake`](https://github.com/richfitz/remake)/[`YAML`](http://yaml.org/) file with the `makefile` and `remakefile` arguments, respectively. You can add lines to the beginning of the [`Makefile`](https://www.gnu.org/software/make/) with the `begin` argument, which could be useful for setting up the workflow for execution on a cluster, for example. You can append commands to `make clean` with the `clean` argument. In addition, the `remake_args` argument passes additional arguments to `remake::make`. For example, `write_makefile(remake_args = list(verbose = FALSE))` is equivalent to `remake::make(..., verbose = F)` for each target. You cannot set `target_names` or `remake_file` this way.

# Use with the [downsize](https://github.com/wlandau/downsize) package

The <a href="https://github.com/wlandau/downsize">downsize</a> package is compatible with <a href="https://github.com/wlandau/parallelRemake">parallelRemake</a> and <a href="https://github.com/wlandau/remakeGenerator">remakeGenerator</a> workflows, and the <a href="https://github.com/wlandau/remakeGenerator">remakeGenerator</a> README suggests one of many potential ways to use these packages together.

# Accessing the [`remake`](https://github.com/richfitz/remake) cache for debugging and testing

Intermediate [`remake`](https://github.com/richfitz/remake) objects are maintained in [`remake`](https://github.com/richfitz/remake)'s hidden [`storr`](https://github.com/richfitz/storr) cache. At any point in the workflow, you can reload them using `recall(obj)`, where `obj` is a character string, and you can see the available values of `obj` with the `recallable()` function. **Important: this is only recommended for debugging and testing. Changes to the cache are not tracked and thus not reproducible.**

# Multiple [`remake`](https://github.com/richfitz/remake) files

[`remake`](https://github.com/richfitz/remake) has the option to split the workflow over multiple [`YAML`](http://yaml.org/) files and collate them with the "include:" field. If that's the case, just specify all the root nodes in the `remakefiles` argument to `write_makefile`. (You could also specify every single [`YAML`](http://yaml.org/) file, but that's tedious.) If needed, `write_makefile` will recursively combine the targets, sources, etc. in the constituent `remakefiles` and output a new collated [`YAML`](http://yaml.org/) file that the master [`Makefile`](https://www.gnu.org/software/make/) will then use.

# High-performance computing

If you want to run `make -j` to distribute tasks over multiple nodes of a [Slurm](http://slurm.schedmd.com/) cluster, refer to the Makefile in [this post](http://plindenbaum.blogspot.com/2014/09/parallelizing-gnu-make-4-in-slurm.html) and write

```{r}
write_makefile(..., 
  begin = c(
    "SHELL=srun",
    ".SHELLFLAGS= <ARGS> bash -c"))
```

in an R session, where `<ARGS>` stands for additional arguments to `srun`. Then, once the [Makefile](https://www.gnu.org/software/make/) is generated, you can run the workflow with
`nohup make -j [N] &` in the command line, where `[N]` is the number of simultaneous tasks.
For other task managers such as [PBS](https://en.wikipedia.org/wiki/Portable_Batch_System), such an approach may not be possible. Regardless of the system, be sure that all nodes point to the same working directory so that they share the same `.remake` [storr](https://github.com/richfitz/storr) cache.
