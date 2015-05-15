## Set locale to English
Sys.setlocale("LC_TIME", "English")

## Get file with data
FileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!file.exists("NEI_data.zip")) {
   download.file(FileUrl, destfile = "NEI_data.zip", method = "curl")
}
unzip("NEI_data.zip")

## Get data
NEI <- readRDS("./data/summarySCC_PM25.rds")
NEI$year <- factor(NEI$year)
NEI_Baltimore <- NEI[NEI$fips == "24510",]
rm(NEI)

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
## variable, which of these four sources have seen decreases in emissions from 1999–2008
## for Baltimore City? Which have seen increases in emissions from 1999–2008?
## Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)
library(plyr)

plot3_data <- ddply(NEI_Baltimore, .(year,type), summarize, TotalEmissions=sum(Emissions))

png('./ExData_Plotting2/plot3.png',
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

ggplot(data = plot3_data, aes(x = year, y = TotalEmissions, fill = type)) +    
   geom_bar(stat="identity", position="dodge") +
   ggtitle("Emission Types in the Baltimore (Maryland)")

dev.off()