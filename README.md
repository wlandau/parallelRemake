# parallelRemake

[![Travis-CI Build Status](https://travis-ci.org/wlandau/parallelRemake.svg?branch=master)](https://travis-ci.org/wlandau/parallelRemake)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/wlandau/parallelRemake?branch=master&svg=true)](https://ci.appveyor.com/project/wlandau/parallelRemake)
[![codecov.io](https://codecov.io/github/wlandau/parallelRemake/coverage.svg?branch=master)](https://codecov.io/github/wlandau/parallelRemake?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/parallelRemake)](http://cran.r-project.org/package=parallelRemake)

The `parallelRemake` package is a helper add-on for [`remake`](https://github.com/richfitz/remake), a [Makefile](https://www.gnu.org/software/make/)-like reproducible build system for R. If you haven't done so already, go learn [`remake`](https://github.com/richfitz/remake)! Also learn [GNU make](https://www.gnu.org/software/make/), and then recall that `make -j 4` runs a [Makefile](https://www.gnu.org/software/make/) while distributing the rules over four parallel processes. This mode of parallelism is the whole point of `parallelRemake`. With `parallelRemake`, you can write an overarching [Makefile](https://www.gnu.org/software/make/) for a [`remake`](https://github.com/richfitz/remake) project to run [`remake`](https://github.com/richfitz/remake) targets in parallel. This distributed parallelism is extremely helpful for large clusters that use the [Slurm job scheduler](http://slurm.schedmd.com/), for example, as explained in [this post](http://plindenbaum.blogspot.com/2014/09/parallelizing-gnu-make-4-in-slurm.html).

# Drake

[Drake](https://github.com/wlandau-lilly/drake) is a standalone reimplementation of the ideas that [remake](https://github.com/richfitz/remake) pioneered, plus some niceties. Like `parallelRemake`, [drake](https://github.com/wlandau-lilly/drake) supports parallel computing with [Makefiles](https://www.gnu.org/software/make/). [Drake](https://github.com/wlandau-lilly/drake) additionally offers  `parallel::mclapply()` and `parallel::parLapply()` as available parallel backends.

# Installation

To install the development version, get the [devtools](https://cran.r-project.org/web/packages/devtools/) package and run

```
devtools::install_github("wlandau/parallelRemake", build = TRUE)
```

If you specify a tag, you can install a GitHub release.

```r
devtools::install_github("wlandau/parallelRemake@v0.0.2", build = TRUE)
```


# Rtools for Windows users

The example and tests sometimes use `system("make")` and similar commands. So if you're using the Windows operating system, you will need to install the [`Rtools`](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows) package.

# Tutorial

The [online package vignette](https://github.com/wlandau/parallelRemake/blob/master/vignettes/parallelRemake.Rmd) has a complete tutorial. You can load the compiled version from an R session.

```r
vignette("parallelRemake")
```


# Help and troubleshooting

Use the `help_parallelRemake()` function to obtain a collection of helpful links. For troubleshooting, please refer to [TROUBLESHOOTING.md](https://github.com/wlandau/parallelRemake/blob/master/TROUBLESHOOTING.md) on the [GitHub page](https://github.com/wlandau/parallelRemake) for instructions.

# Acknowledgements

This package stands on the shoulders of [Rich FitzJohn](https://richfitz.github.io/)'s [`remake`](https://github.com/richfitz/remake) package. Also thanks to [Daniel Falster](http://danielfalster.com/) for [the idea](https://github.com/richfitz/remake/issues/84) that made `parallelRemake` practical and clean.
