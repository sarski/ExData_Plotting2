library(dplyr)

# download and unzip the contents of the zipfile to local drive
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "NEI-data.zip", method = "curl")
unzip("NEI-data.zip")

# read file into R
NEI <- readRDS("summarySCC_PM25.rds")

plot2data <- filter(NEI, fips == "24510") %>% # select data from Baltimore City
    select(year, Emissions) %>% # select necessary columns for plot
    group_by(year) %>% # split dataset by year
    summarise(sum(Emissions)) # get sum of Emissions for each year

# open PNG device and create plot in working directory
png("plot2.png")

# plot sum(Emissions) vs. year
plot(plot2data$year, plot2data$`sum(Emissions)`, pch = 20, 
     main = "Total PM2.5 Emissions in Baltimore City, MD (1999-2008)",
     xlab = "Year", ylab = "Total PM2.5 emissions (tons)")
abline(lm(`sum(Emissions)` ~ year, plot2data))

# close PNG device
dev.off()