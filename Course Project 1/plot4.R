## Getting  the full Dataset
# check if a data folder exists; if not then create one
if (!file.exists("data")) {dir.create("data")}

# Check if file exits; if not download and unzip the file
if (!file.exists("./data/household_power_consumption.txt")) {
  # file URL, destination zip file, destination data file
  URLArchivo <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  ArchivoDestino <- "./data/power_consumption.zip"
  ArchivoDatos <- "./data/household_power_consumption.txt"
  
  # Download the file and note the time
  download.file(URLArchivo, ArchivoDestino)
  dateDownloaded <- date()
  # Unzip the data file
  unzip(ArchivoDestino, exdir = "./data/", overwrite = TRUE, getOption(ArchivoDatos))
}

# set the file to read
allData <- file(ArchivoDatos, "r");

# Read in the data until the two days 
twoDaysData <- read.table(text = grep("^[1,2]/2/2007", readLines(allData), value = TRUE), 
                          sep = ";", skip = 0, na.strings = "?", stringsAsFactors = FALSE)

# Cleaning allData from memory
rm(allData)

# Change the columns names
names(twoDaysData) <- c("date", "time", "active_power", "reactive_power", "voltage",
                        "intensity", "sub_metering_1", "sub_metering_2", 
                        "sub_metering_3")

# Insert in the twodays data set a new date-time formated column
twoDaysData$new_time <- as.POSIXct(paste(twoDaysData$date, twoDaysData$time), format = "%d/%m/%Y %T")


## Making Plot 4
par(mfrow=c(2,2))
with(twoDaysData, {
    plot(new_time, active_power, type= "l", ylab= "Global Active Power", xlab="")
    plot(new_time, voltage, type= "l", ylab= "Voltage", xlab="")
    plot(new_time, sub_metering_1, type= "l", ylab= "Energy sub metering", xlab= "")
    lines(new_time, sub_metering_2 ,col= "red")
    lines(new_time, sub_metering_3, col= "blue")
    legend("topright", col=c("black", "red", "blue"), cex = 0.7, lty=1, bty="n",
           legend=c("Sub_metering_1", 
                    "Sub_metering_2", 
                    "Sub_metering_3"))
    plot(new_time, reactive_power,  type= "l", ylab= "Global Rective Power",xlab="")
})

## Make a copy from Plot 4 to a .png file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
