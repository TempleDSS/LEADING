#Author: Eiman Ahmed
#Date: 09/14/22
#Temple University Lab

#Install necessary packages
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("ggmap")
#install.packages("viridis")

#Read necessary libraries
library(tidyverse)
library(ggplot2)
library(ggmap)
library(viridis)

#Read latest Property Data downloaded from the OpenDataPhilly organization
property_data <- 
  read.csv("https://opendata-downloads.s3.amazonaws.com/opa_properties_public.csv")

#First examine the measures of central tendency 
#Mean market value of homes in Philadelphia appears to be 352,160
#Median market value of homes in Philadelphia appear to be 176,600
summary(property_data$market_value)

#Plot market value of homes against zipcode to see whether a correlation exists
plot(property_data$zip_code, property_data$market_value,
     xlim = c(19100, 19160))

#Based on the above plot, there doesnt seem to be an apparent correlation
#between location in Philadelphia and the market value of homes

#Pearson's correlation are used to see if there is a correlation 
#more statistically speaking
cor.test(property_data$zip_code, property_data$market_value, 
         use = "complete.obs")

#The test finds that there is a strong, but small correlation between 
#location and home values in Philadelphia (p < 0.05)

#A heatmap is created to better see how market value of homes differ based
#on location in the city
google_key = "" #Enter your key here
register_google(key = google_key)
map_philly <- get_map('Philadelphia', zoom = 12)

subset_property <- property_data[,c("market_value","lng","lat")]

ggmap(map_philly) +
  stat_density2d(data = subset_property, aes(x = lng, y = lat, fill = ..level..), 
                 geom = 'tile', contour = F, alpha = .5) +  scale_fill_viridis()