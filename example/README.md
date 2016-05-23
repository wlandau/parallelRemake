# Run the example

- Ensure that [R](https://www.r-project.org/), the [`parallelRemake`](https://github.com/wlandau/parallelRemake/) package, and [GNU make](https://www.gnu.org/software/make/) are installed.
- Run Makefile.R in an R session to generate the [Makefile](https://www.gnu.org/software/make/) and its constituent [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) files.
- Open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html).
- Enter `make` into the command line to run the full workflow. To distribute the work over multiple parallel process, you can instead type `make -j <n>` where `<n>` is the number of processes.
- Verify that the generated plot `my_plot.pdf` looks similar to the provided example plot `my_plot.jpg`.
- Optionally, clean up the output. Typing `make clean` removes the files produced by `make`. Similarly, `make clean_yaml` removes the [YAML](http://yaml.org/) files produced by `write_yaml`, `make clean_makefile` removes the [Makefile](https://www.gnu.org/software/make/), and `make clean_all` is equivalent to `make clean clean_yaml clean_makefile`.

# Details

The  is available for download. In this workflow, I

1. Generate four data frames, each with 1000 rows and columns `x` and `y`.
2. Take the column means of each data frame.
3. Plot the column means as below, where each point corresponds to a data frame.

<div style = "text-align:center">
<img src="my_plot.jpg" width = 375px height = 375px/>
</div>

Normally, this 3-task workflow would be an easy job for [`remake`](https://github.com/richfitz/remake). However, let's say I want run tasks (1) and (2) in parallel processes, with one process per dataset. The [`remake`](https://github.com/richfitz/remake) package does not allow for much parallelism because it runs in a single R session, so I use `parallelRemake` to run pieces of the workflow in parallel instances of [`remake`](https://github.com/richfitz/remake). At the end of this tutorial, you will be able to call `make -j` to distribute the work over multiple parallel processes.

First, let's define the functions for generating data, saving column means, and plotting. I keep them in [`code.R`](https://github.com/wlandau/parallelRemake/blob/master/example/code.R) below.

```{r}
generate_data = function(){
  data.frame(
    x = rnorm(1000), 
    y = rnorm(1000, mean = 16)
  )
}

save_column_means = function(dataset, rep){
  out = colMeans(dataset)
  saveRDS(out, paste0("column_means", rep, ".rds"))
}

my_plot = function(...){
  column_means = do.call(rbind, lapply(list(...), readRDS))
  plot(y ~ x, data = column_means)
}
```

Next, I generate a [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) file for each "step" of the workflow. In this case, I create one [YAML](http://yaml.org/) file (i.e., step) per dataset for tasks (1) and (2) and a single [YAML](http://yaml.org/) file for task (3). I could write these [YAML](http://yaml.org/) files by hand, but for big simulation studies, this is cumbersome and prone to human error. Below, I automate the production of the [YAML](http://yaml.org/) files. Specifically, I use `write_yaml` to produce each [YAML](http://yaml.org/) file from a named list.

```{r}
library(parallelRemake) 

# Number of datasets to generate with generate_data().
reps = 4

# Encode remake/YAML instructions to generate multiple datasets
# and take the column means of each dataset.
for(rep in 1:reps){ 
  dataset = paste0("dataset", rep)  
  column_means = paste0("column_means", rep, ".rds") 

  # Initialize YAML fields.
  fields = list(
    sources = "code.R",
    targets = list(
      all = list(depends = column_means)
    )
  )

  # Add a target to create the data.
  fields$targets[[dataset]] = list(command = "generate_data()")

  # Add a target to take the column means of a dataset.
  my_command = paste0("save_column_means(dataset = dataset", rep, ", rep = ", rep, ")")
  fields$targets[[column_means]] = list(command = my_command)

  # Write the YAML file for remake.
  write_yaml(fields, paste0("step", rep, ".yml"))
}

# Character string of the RDS files containing the column means.
files = paste(paste0("\"column_means", 1:reps, ".rds\""), collapse = ", ")

# Write the remake/YAML file for plotting the column means of the datasets
# initialize YAML fields
fields = list(
  sources = "code.R",
  targets = list(
    all = list(depends = "my_plot.pdf"),
    my_plot.pdf = list(
      command = paste0("my_plot(", files, ")"),
      plot = "TRUE"
    )
  )
)

# Write the plotting YAML file
write_yaml(fields, "my_plot.yml")
```

Next, I organize the workflow steps (i.e., [YAML](http://yaml.org/) files) into parallelizable stages of the workflow. Within each stage, the steps can be run in separate parallel processes. 

```{r}
stages = list(
  stage1 = paste0("step", 1:reps, ".yml"),
  stage2 = "my_plot.yml"
)
```

Above, I include the `.yml` extensions of the files, but you have the option to omit them. This organization of steps into stages is encoded in the overarching [Makefile](https://www.gnu.org/software/make/) produced by `write_makefile`. 

```{r}
write_makefile(stages)
```

With a [Makefile](https://www.gnu.org/software/make/) in hand, I can easily run the whole workflow. First, I open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html). To run the workflow with 4 parallel processes, I type `make -j 4`. I could have changed the number of processes by substituting a different integer in place of 4 or simply typed `make` to run the workflow steps sequentially in a single process. 

There are several ways to clean up the output. Typing `make clean` removes the files produced by `make`. Similarly, `make clean_yaml` removes the [YAML](http://yaml.org/) files produced by `write_yaml`, `make clean_makefile` removes the [Makefile](https://www.gnu.org/software/make/), and `make clean_all` is equivalent to `make clean clean_yaml clean_makefile`.