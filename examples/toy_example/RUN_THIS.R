# First example in 

library(workflowHelper)

stages = list(
  paste0("remake", 1:3),
  paste0("remake", 4:6)
)

write_workflow(stages)

# Next, try running `make` or `make -j 3` from the command line.
# Run `make clean` to get rid of everything generated except the YAML files.
