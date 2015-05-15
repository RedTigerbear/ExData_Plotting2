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

##  Across the United States, how have emissions from coal combustion-related sources
## changed from 1999–2008?
library(ggplot2)
library(plyr)

coal <- grep("coal", SCC$EI.Sector, ignore.case=TRUE, value=TRUE)
coalSCC_data <- subset(SCC, EI.Sector %in% coal)
coal_data<-merge(subset(NEI, SCC %in% coalSCC_data$SCC), coalSCC_data, by="SCC")

plot4_data <- ddply(coal_data, .(year), summarize, TotalEmissions=sum(Emissions) / 100000)

png('./ExData_Plotting2/plot4.png',
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

ggplot(data = plot4_data, aes(x = year, y = TotalEmissions) ) + 
   geom_bar(stat="identity", position = "dodge") +
   ylab(expression('Total PM '[2.5]*"  Emissions, "*'10'^5)) +
   ggtitle("Coal Combustion-Related Emissions in 1999, 2002, 2005, 2008")

dev.off()