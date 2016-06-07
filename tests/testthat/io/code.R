generate_data = function(){
  data(mtcars)
  write.csv(mtcars, file = "data.csv")
}

process_data = function(filename){
  d = read.csv(filename)
  data.frame(x = d$mpg, y = d$cyl)
}

myplot = function(data){
  plot(y~x, data = data)
}
