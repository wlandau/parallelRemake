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
