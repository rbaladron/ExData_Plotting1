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


## Making Plot 3
par(mfrow = c(1, 1))
with(twoDaysData, {
    plot(new_time, sub_metering_1, 
         type="l",
         ylab="Energy sub metering", 
         xlab="")
    lines(new_time, sub_metering_2, col='Red')
    lines(new_time, sub_metering_3, col='Blue')

legend("topright", col=c("black", "red", "blue"), cex = 0.8, lty=1,  
       legend = c("Sub_metering_1    ",
                  "Sub_metering_2    ",
                  "Sub_metering_3    "))

})
## Make a copy to a .png file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
