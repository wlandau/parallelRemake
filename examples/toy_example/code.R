wrapper_function = function(file){
  generate_data(file)
}

generate_data = function(file){
  data(mtcars)
  n = dim(mtcars)[1]
 # mtcars$cyl = rpois(n, 5) # COMMENT/UNCOMMENT THIS LINE TO SEE HOW remake::make() RESPONDS
  write.csv(mtcars, file = file)
}

process_data = function(filename){
  d = read.csv(filename)
  data.frame(x = d$mpg, y = d$cyl)
}

myplot = function(data){
  plot(y~x, data = data)
}
