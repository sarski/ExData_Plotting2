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
plot4SCC <- filter(SCC, (grepl("combustion", SCC.Level.One, ignore.case = TRUE) 
                         | grepl("combustion", SCC.Level.Two, ignore.case = TRUE)) 
                   & (grepl("coal", SCC.Level.Three, ignore.case = TRUE) 
                      | grepl("coal", SCC.Level.Four, ignore.case = TRUE)))

plot4data <- filter(NEI, SCC %in% plot4SCC$SCC) %>% #select data based of SCC filter
    group_by(year) %>% # split dataset by year
    summarise(sum(Emissions)) # get sum of Emissions for each year

# open PNG device and create plot in working directory
png("plot4.png", width = 720, height = 480)

# plot sum(Emissions) vs. year
plot4 <- ggplot(plot4data, aes(year, `sum(Emissions)`))
plot4 + 
    geom_point(size = 4) + 
    geom_smooth(method = "lm", se = FALSE) + 
    labs(x = "Year") + 
    labs(y = expression("Total " * PM[2.5] * " Emissions (tons)")) + 
    labs(title = expression("Total " * PM[2.5] * " Emissions in the United States from Coal Combustion-Related Sources (1999-2008)"))

# close PNG device
dev.off()
