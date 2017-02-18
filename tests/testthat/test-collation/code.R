generate_data = function(){
  data(mtcars)
  mtcars
}

process_data = function(d){
  data.frame(x = d$mpg, y = d$cyl)
}

myplot = function(data){
  plot(y~x, data = data)
}
