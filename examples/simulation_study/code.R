# Functions to generate datasets
my_norm = function(file, size = 20){
  out = data.frame(
    x = rnorm(size),
    y = rnorm(size)
  )
  saveRDS(out, file = file)
}

my_cars = function(file){
  data(mtcars)
  out = data.frame(
    x = mtcars$mpg,
    y = mtcars$cyl # + 1 ## UNCOMMENT TO SEE HOW REMAKE RESPONDS TO CHANGE
  )
  saveRDS(out, file = file)
}

# Functions to analyze datasets
my_ols = function(file){
  d = readRDS(file)
  lm(y ~ x, data = d)
}

my_rpart = function(file){
  d = readRDS(file)
  library(rpart)
  rpart(y ~ x, data = d)
}

# Summarize analyses
my_predict = function(fit, file){
  out = predict(fit, newdata = data.frame(x = c(1, 5, 20)))
  saveRDS(out, file = file)
}

# Make plots
my_scatter = function(file1, file2){
  x = readRDS(file1)
  y = readRDS(file2)
  plot(y ~ x)
}
