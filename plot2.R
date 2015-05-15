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

## Have total emissions from PM2.5 decreased in the Baltimore City,
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system
## to make a plot answering this question.
plot2_data <- tapply(NEI_Baltimore$Emissions, INDEX=NEI_Baltimore$year, sum)

png('./ExData_Plotting2/plot2.png',
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

barplot(plot2_data,
        main = expression('PM'[2.5]*" Emissions in the Baltimore (Maryland) from 1999 to 2008"),
        ann = F)
mtext(side = 1,
      text = "Year",
      line = 2)
mtext(side = 2,
      text = expression('Total PM '[2.5]*"  Emissions"),
      line = 2)

dev.off()