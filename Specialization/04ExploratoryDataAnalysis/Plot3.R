#Exploring Data Analysis Project 1 - Plot3 
library("readr")
library("RSQLite")
library("sqldf")
#Step 1 - Loading the data
url1 <- https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
download.file(url1,destfile="./household_power_consumption.txt")
# Loading data in to R for only for dates 2007-02-01 and 2007-02-02
EPCdata <- read.csv.sql("./household_power_consumption.txt", sep=";", 
                        sql = "select * from file where Date in ('1/2/2007', '2/2/2007')",
                        colClasses = rep("character", 9))
## Convert all measurement columns as numeric
EPCdata[,3:9] <- lapply(EPCdata[,3:9], as.numeric)
# Conveting the Time column into date & time
EPCdata$Time  <- strptime(paste(EPCdata$Date, EPCdata$Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")
# Converting Date column to date formart
EPCdata$Date  <- as.Date(as.character(EPCdata$Date),"%d/%m/%Y")
#---
#Step 2 - Making Plot 1 - Making Plot 3 - Submetering by date & time 
#---
png(file="plot3.png", width = 480, height = 480, units = "px")
with(EPCdata,{
        plot(EPCdata$Time,EPCdata$Sub_metering_1,type="n",xlab="",ylab="Energy Sub metering")
        lines(EPCdata$Time,EPCdata$Sub_metering_1)
        lines(EPCdata$Time,EPCdata$Sub_metering_2,col="red")
        lines(EPCdata$Time,EPCdata$Sub_metering_3,col="blue")
        legend("topright",pch=c("-"),col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
})
dev.off()