## The plot1.R does the following.
##       1. Download the data from the URL
##       2. Extract the ZIP file
##       3. Read the data while filtering it to sepcific dates
##       4. Create date time field and change data type to numeric for global active power
##       5. Open graphics device png and write the historgram before closing the device
## Please refer plot1.R for output


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

## Optional Code
#dataFile <- "household_power_consumption.txt"
#data <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".", na.strings = "?")
#data <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

# Parse the date and time columns
data$DateTime <- paste(data$Date, data$Time)
data$DateTime <- as.POSIXct(data$DateTime,"%d/%m/%Y %H:%M:%S", tz = "EST5EDT")

# Convert Global Active Power to Numeric
data$Global_active_power <- as.numeric(data$Global_active_power)

# Opening the graphics device as the PNG image format
png("plot1.png", width=480, height=480)

# Painting the graph
hist(data$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

# Closing the file connection
dev.off()




