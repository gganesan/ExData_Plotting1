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
  dt[dt$Global_active_power == '?'] <- "NA"
  
  # set class numeric to Global_active_power and omit NA
  dt$Global_active_power = as.numeric(dt$Global_active_power)
  dt = na.omit(dt)
  
  ## set Date as factor
  #dt$Date = factor(weekdays(dt$Date))
  
  #draw histogram
  hist(dt$Global_active_power, col= "red", xlab = "Global Active Power (Kilowatts)", main = "Global Active Power")
  
  #copy to file
  dev.copy(png, file = "plot1.png")
  dev.off() 

}