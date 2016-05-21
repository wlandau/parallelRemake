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
  column_means = t(sapply(1:reps, function(rep){
    file = paste0("column_means", rep, ".rds")
    readRDS(file)
  }))
  plot(y ~ x, data = column_means, 
    xlab = "Means of x", ylab = "Means of y",
    pch = 16, cex = 2, cex.axis = 1.25, cex.lab = 1.5)
}
