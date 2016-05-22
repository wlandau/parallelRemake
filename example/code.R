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
