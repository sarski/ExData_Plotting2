library(dplyr)
library(ggplot2)

# download and unzip the contents of the zipfile to local drive
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "NEI-data.zip", method = "curl")
unzip("NEI-data.zip")

# read file into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# create data frame from SCC containing "Coal" and "Combustion"
plot6SCC <- filter(SCC, grepl("vehicle", SCC.Level.Two, ignore.case = TRUE) | 
                       grepl("vehicle", SCC.Level.Three, ignore.case = TRUE) | 
                       grepl("vehicle", SCC.Level.Four, ignore.case = TRUE))

plot6data <- filter(NEI, (fips == "06037" | fips == "24510") & SCC %in% plot6SCC$SCC) %>% #select data from LA County and Baltimore City based of SCC filter
    group_by(year, fips) %>% # split dataset by year and fips
    summarise(sum(Emissions)) %>% # get sum of Emissions for each year
    transform(fips = factor(fips)) # set fips as factor class
levels(plot6data$fips) <- c("LA County", "Baltimore City")


# open PNG device and create plot in working directory
png("plot6.png", width = 960, height = 480)

# plot sum(Emissions) vs. year
plot6 <- ggplot(plot6data, aes(year, sum.Emissions.))
plot6 + 
    geom_point(size = 4) +
    facet_grid(. ~ fips) +
    geom_smooth(method = "lm", se = FALSE) + 
    labs(x = "Year") + 
    labs(y = expression("Total " * PM[2.5] * " Emissions (tons)")) + 
    labs(title = expression("Total " * PM[2.5] * " Emissions from Motor Vehicle Sources in Los Angeles County, CA vs. Baltimore City, MD (1999-2008)"))

# close PNG device
dev.off()
