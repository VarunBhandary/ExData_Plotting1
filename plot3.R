## The plot3.R does the following.
##       1. Download the data from the URL
##       2. Extract the ZIP file
##       3. Read the data while filtering it to sepcific dates
##       4. Create date time field and change data type to numeric for global active power
##       5. Open graphics device png and write the line graph with Date Time before closing the device
## Please refer plot3.png for output


library(sqldf)
library(lubridate)
library(ggplot2)

# Download the zipped data file from the URL and save the contents at 
# a specific location

DataZipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
DataZipFileName <- "UCI HAR Dataset.zip"

if (!file.exists(DataZipFileName)) {
        download.file(DataZipUrl, DataZipFileName, mode = "wb")
}
print(paste(c("Data downloaded from the URL "), DataZipUrl))

dataPath <- "UCI HAR Dataset"
if (file.exists(dataPath)) {
        unzip(DataZipFileName)
} else {
        dir.create(dataPath)
        unzip(DataZipFileName)
}
print(paste(c("Unzipped the data to the following folder"), dataPath))

#reading the data file. Another option is SQLDF to filter while reading CSV to optimise loads
data <- read.csv.sql("household_power_consumption.txt", sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'", sep = ";")
closeAllConnections()
## Optional Code
#dataFile <- "household_power_consumption.txt"
#data <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".", na.strings = "?")
#data <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

# Parse the date and time columns
data$DateTime <- paste(data$Date, data$Time)
data$DateTime <- as.POSIXct(data$DateTime,"%d/%m/%Y %H:%M:%S", tz = "EST5EDT")

# Convert Global Active Power and sub meterings to Numeric
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)


# Opening the graphics device as the PNG image format
png("plot3.png", width=480, height=480)

# Painting the graph
plot(data$DateTime, data$Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(data$DateTime, data$Sub_metering_2, type="l", col="red")
lines(data$DateTime, data$Sub_metering_3, type="l", col="blue")

legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))

# Closing the file connection
dev.off()
