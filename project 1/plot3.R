library(data.table)
## check if file exists
if(!file.exists("household_power_consumption.txt")){
  print("Error: File does not exist\n")
}else{

  ## read the date 
  dt = fread("household_power_consumption.txt",nrows = -1, na.strings = '?')
  
  # set the col 1 as Date class
  dt$Date = as.Date(dt$Date, "%d/%m/%Y")
  setkey(dt, "Date")
  
  #identify rows with Dates from 2007-02-01 and 2007-02-02
  dt = subset(dt, (Date == as.Date("01/02/2007", "%d/%m/%Y") | Date == as.Date("02/02/2007", "%d/%m/%Y")))
  
  #replace '?' with NA
  dt[dt$Sub_metering_1 == '?'] <- "NA"
  dt[dt$Sub_metering_2 == '?'] <- "NA"
  dt[dt$Sub_metering_3 == '?'] <- "NA"
  
  # set class numeric to Global_active_power and omit NA
  dt$Sub_metering_1 = as.numeric(dt$Sub_metering_1)
  dt$Sub_metering_2 = as.numeric(dt$Sub_metering_2)
  dt$Sub_metering_3 = as.numeric(dt$Sub_metering_3)
  dt = na.omit(dt)
  

  a = strptime(paste(dt$Date, dt$Time), format = "%Y-%m-%d %H:%M:%S" )
  plot(a, dt$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", col = "black")
  lines(a, dt$Sub_metering_2, col = "red")
  lines(a, dt$Sub_metering_3, col = "blue")
  axis(1, at=c(min(dt$Date), min(dt$Date)+86400,  min(dt$Date)+2*86400),
       labels=c("Thu", "Fri", "Sat"))
  legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lty = c(1,1,1),
  col = c("black", "red", "blue"))
  
  #copy to file
  dev.copy(png, file = "plot3.png")
  dev.off()
 
}