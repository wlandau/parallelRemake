my_mtcars = function(){
  data(mtcars)
  mtcars
}

my_random = function(){
  data.frame(y = rnorm(32))
}

my_plot = function(mtcars, random){
  plot(mtcars$mpg, random$y)
}
