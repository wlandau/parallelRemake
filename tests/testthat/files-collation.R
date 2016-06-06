code = "generate_data = function(){\n  data(mtcars)\n  write.csv(mtcars, file = \"data.csv\")\n}\n\nprocess_data = function(filename){\n  d = read.csv(filename)\n  data.frame(x = d$mpg, y = d$cyl)\n}\n\nmyplot = function(data){\n  plot(y~x, data = data)\n}"

remake = "include: remake2.yml\n\nsources:\n  - code.R\n\ntargets:\n  all:\n    depends: \n      - plot1.pdf\n      - plot2.pdf\n      - plot3.pdf"

remake2 = "include:\n  - remake3.yml\n  - remake4.yml\n\ntargets:\n  plot1.pdf:\n    command: myplot(processed1)\n    plot: TRUE"

remake3 = "include: remake5.yml\n\ntargets:\n  processed1:\n    command: process_data(\"data.csv\")\n\n  processed2:\n    command: process_data(\"data.csv\")"

remake4 = "targets:\n  processed3:\n    command: process_data(\"data.csv\")"

remake5 = "targets:\n  plot2.pdf:\n    command: myplot(processed2)\n    plot: TRUE\n\n  plot3.pdf:\n    command: myplot(processed3)\n    plot: TRUE"

remake_data = "targets:\n  data.csv:\n    command: generate_data()"
