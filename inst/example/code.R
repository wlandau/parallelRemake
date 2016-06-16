download_data = function(){
  data(mtcars)
# mtcars$mpg = mtcars$mpg + 1 # TOGGLE THIS LINE TO FORCE A REBUILD
  write.csv(mtcars, "data.csv")
}

process_data = function(file){
  read.csv(file)
}

myplot = function(d){
  plot(cyl ~ mpg, data = d)
}
