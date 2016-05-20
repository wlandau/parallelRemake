This R package helps to manage large R workflows. It uses [GNU make](https://www.gnu.org/software/make/) and the [`remake`](https://github.com/richfitz/remake) package to do work in parallelizable stages.

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

# An example

In this workflow, I

1. Generate four data frames.
2. Take the column means of each data frame.
3. Plot the column means.

Normally, this would be an easy job for [`remake`](https://github.com/richfitz/remake). However, let's say I want run tasks (1) and (2) in parallel processes, with one process per dataset. The [`remake`](https://github.com/richfitz/remake) package does not allow for much parallelism because it runs in a single R session, so I use `workflowHelper` to run pieces of the workflow in parallel instances of [`remake`](https://github.com/richfitz/remake).

First, let's define the functions for generating data, saving column means, and plotting. I keep them in `code.R` below.

```
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

my_plot = function(reps){
  column_means = NULL
  for(rep in 1:reps){
    file = paste0("column_means", rep, ".rds")
    column_means = rbind(column_means, readRDS(file))
  }
  plot(y ~ x, data = column_means, pch = 16)
}
```

Next, I generate a [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) file for each "step" of the workflow. In this case, I create one [YAML](http://yaml.org/) file (i.e., step) per dataset for tasks (1) and (2) and a single [YAML](http://yaml.org/) file for task (3). I could write these [YAML](http://yaml.org/) files by hand, but for big simulation studies, this is cumbersome and prone to human error. Below, I automate the production of the [YAML](http://yaml.org/) files. Specifically, I use `write_step` to produce each [YAML](http://yaml.org/) file from a named list.

```
# Install from https://github.com/wlandau/workflowhelper
# Also requires the remake package at https://github.com/richfitz/remake
library(workflowHelper) 

# Number of datasets to generate with generate_data().
reps = 4

# Encode remake/[YAML](http://yaml.org/) instructions to generate multiple datasets
# and take the column means of each dataset.
for(rep in 1:reps){ 
  dataset = paste0("dataset", rep)  
  column_means = paste0("column_means", rep, ".rds") 

  # Initialize [YAML](http://yaml.org/) fields.
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

  # Write the [YAML](http://yaml.org/) file for remake.
  write_step(fields, paste0("step", rep, ".yml"))
}

# Write the remake/[YAML](http://yaml.org/) file for plotting the column means of the datasets
# initialize [YAML](http://yaml.org/) fields
fields = list(
  sources = "code.R",
  targets = list(
    all = list(depends = "my_plot.pdf"),
    my_plot.pdf = list(
      command = paste0("my_plot(reps = ", reps, ")"),
      plot = "TRUE"
    )
  )
)

# Write the plotting [YAML](http://yaml.org/) file
write_step(fields, "my_plot.yml")
```

Next, I organize the workflow steps (i.e., [YAML](http://yaml.org/) files) into parallelizable stages of the workflow. Within each stage, the steps can be run in separate parallel processes.

```
stages = list(
  stage1 = paste0("step", 1:reps, ".yml"),
  stage2 = "my_plot.yml"
)
```

This organization of steps into stages is encoded in the overarching [Makefile](https://www.gnu.org/software/make/) produced by `write_workflow`.

```
write_workflow(stages)
```

With a [Makefile](https://www.gnu.org/software/make/) in hand, I can easily run the whole workflow. First, I open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) in the [current working directory](https://en.wikipedia.org/wiki/Working_directory). To run the workflow with 4 parallel processes, I type `make -j 4`. To change the number of processes,) substitute a different number for 4. To run the workflow sequentially in a single process, I simply type `make`. To clean up, the generated output, I type `make clean`.
