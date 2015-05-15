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

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission
## from all sources for each of the years 1999, 2002, 2005, and 2008.
plot1_data <- tapply(NEI$Emissions/1000000, INDEX=NEI$year, sum)

png('./ExData_Plotting2/plot1.png',
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

barplot(plot1_data,
        main = expression('PM'[2.5]*" Emissions in the United States from 1999 to 2008"),
        ann = F)
mtext(side = 1,
      text = "Year",
      line = 2)
mtext(side = 2,
      text = expression('Total PM '[2.5]*"  Emissions, "*'10'^6),
      line = 2)

dev.off()