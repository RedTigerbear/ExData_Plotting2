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
NEI_Baltimore_LA <- NEI[NEI$fips == "24510" | NEI$fips == "06037",]
rm(NEI)

## Compare emissions from motor vehicle sources in Baltimore City with emissions from
## motor vehicle sources in Los Angeles County, California (fips == "06037"). Which
## city has seen greater changes over time in motor vehicle emissions?
cities <- rbind(list(fips="24510",City.Name="Baltimore City"), list("06037","Los Angeles County"))

NEI_Baltimore_LA = merge(NEI_Baltimore_LA, cities, by="fips")
NEI_Baltimore_LA$City.Name = as.character(NEI_Baltimore_LA$City.Name)

plot6_data<-ddply(NEI_Baltimore_LA, .(year,City.Name), summarize, TotalEmissions=sum(Emissions))

png('./ExData_Plotting2/plot6.png',
    width = 600, height = 480, units = "px", pointsize = 12,
    bg = "white") ## Save to file

ggplot(data = plot6_data, aes(x = year, y = TotalEmissions, fill = City.Name)) + 
   geom_bar(stat="identity", position = "dodge", width = 0.5) + 
   ggtitle("Emissions from motor vehicle sources in \n Baltimore City (Maryland) and Los Angeles County (California)") + 
   theme(plot.title = element_text(hjust = 0.5))

dev.off()