## Set locale to English
Sys.setlocale("LC_TIME", "English")

## Get file with data
FileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!file.exists("NEI_data.zip")) {
   download.file(FileUrl, destfile = "NEI_data.zip", method = "curl")
}
unzip("NEI_data.zip")

## Get data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
NEI$year <- factor(NEI$year)
NEI_Baltimore <- NEI[NEI$fips == "24510",]
rm(NEI)

## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore
## City?
vehicle <- grep("vehicle", SCC$EI.Sector, ignore.case=TRUE, value=TRUE)
vehicleSCC_data <- subset(SCC, EI.Sector %in% vehicle)
vehicle_data<-merge(subset(NEI_Baltimore, SCC %in% vehicleSCC_data$SCC), vehicleSCC_data, by="SCC")

plot5_data<-ddply(vehicle_data, .(year), summarize, TotalEmissions=sum(Emissions))

png('./ExData_Plotting2/plot5.png',
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

ggplot(data = plot5_data, aes(x = year, y = TotalEmissions)) + 
   geom_bar(stat="identity", position = "dodge", fill = "dark grey", width = 0.5) + 
   ggtitle("Emissions from motor vehicle sources in Baltimore City (Maryland)")

dev.off()