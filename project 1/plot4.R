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
  dt[dt$Global_active_power == '?'] <- "NA"
  dt[dt$Voltage == '?'] <- "NA"
  dt[dt$Global_reactive_power == '?'] <- "NA"
  
  # set class numeric to Global_active_power and omit NA
  dt$Global_active_power = as.numeric(dt$Global_active_power)
  dt$Sub_metering_1 = as.numeric(dt$Sub_metering_1)
  dt$Sub_metering_2 = as.numeric(dt$Sub_metering_2)
  dt$Sub_metering_3 = as.numeric(dt$Sub_metering_3)
  dt$Voltage = as.numeric(dt$Voltage)
  dt$Global_reactive_power = as.numeric(dt$Global_reactive_power)
  
  dt = na.omit(dt)
  

  a = strptime(paste(dt$Date, dt$Time), format = "%Y-%m-%d %H:%M:%S" )
  par(mfrow = c(2,2))
  with( dt,{
    plot(a, dt$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
        
    plot(a, dt$Voltage, type = "l", ylab = "Voltage", xlab = "")
    
    plot(a, dt$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", col = "black")
    lines(a, dt$Sub_metering_2, col = "red")
    lines(a, dt$Sub_metering_3, col = "blue")
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty = c(1,1,1),
           col = c("black", "red", "blue"),
           bty = "n")
    
    plot(a, dt$Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "")
    
    axis(1, at=c(min(dt$Date), min(dt$Date)+86400,  min(dt$Date)+2*86400),labels=c("Thu", "Fri", "Sat"))
  })
  
  #copy to file
  dev.copy(png, file = "plot4.png")
  dev.off()
 
}