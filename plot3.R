library(dplyr)
library(ggplot2)

# download and unzip the contents of the zipfile to local drive
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "NEI-data.zip", method = "curl")
unzip("NEI-data.zip")

# read file into R
NEI <- readRDS("summarySCC_PM25.rds")

plot3data <- filter(NEI, fips == "24510") %>% # select data from Baltimore City
    group_by(year, type) %>% # split dataset by year
    summarise(sum(Emissions)) %>% # get sum of Emissions for each year
    transform(type = factor(type)) # set type as factor class

# open PNG device and create plot in working directory
png("plot3.png", width = 960, height = 480)

# plot sum(Emissions) vs. year
plot3 <- ggplot(plot3data, aes(year, sum.Emissions.))
plot3 + 
    geom_point() + 
    facet_grid(. ~ type) + 
    geom_smooth(method = "lm", se = FALSE) + 
    labs(x = "Year") + 
    labs(y = expression("Total " * PM[2.5] * " Emissions (tons)")) + 
    labs(title = expression("Total " * PM[2.5] * " Emissions in Baltimore City, MD (1999-2008)"))

# close PNG device
dev.off()
