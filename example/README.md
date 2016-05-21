This folder contains the example from [parallelRemake/README.md](https://github.com/wlandau/parallelRemake/blob/master/README.md). Run it as follows.

- Ensure that [R](https://www.r-project.org/), the [`parallelRemake`](https://github.com/wlandau/parallelRemake/) package, and [GNU make](https://www.gnu.org/software/make/) are installed.
- Run Makefile.R in an R session to generate the [Makefile](https://www.gnu.org/software/make/) and its constituent [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) files.
- Open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html).
- Enter `make` into the command line to run the full workflow. To distribute the work over multiple parallel process, you can instead type `make -j <n>` where `<n>` is the number of processes.
- Verify that the generated output `my_plot.pdf` looks like the provided example output `my_plot.jpg`.
- Optionally, clean up the output. Typing `make clean` removes the files produced by `make`. Similarly, `make clean_yaml` removes the [YAML](http://yaml.org/) files produced by `write_yaml`, `make clean_makefile` removes the [Makefile](https://www.gnu.org/software/make/), and `make clean_all` is equivalent to `make clean clean_yaml clean_makefile`.