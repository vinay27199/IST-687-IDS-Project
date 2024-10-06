#importing Libraries
library(arrow)
library(tidyverse)
#reading the house data
house <- read_parquet("https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/static_house_info.parquet")
#creating a dublicate building id as character
house$building_id <- as.character(house$bldg_id)
#creating the links for each house energy data
house$details <- paste("https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/2023-houseData/",
                       house$building_id,".parquet" ,sep = "")
#creating the links for each county for which has weather data
house$weather_data <- paste("https://intro-datascience.s3.us-east-2.amazonaws.com/SC-data/weather/2023-weather-data/",
                            house$in.county,".csv" ,sep = "")
#View(house)
house <- house[house$in.building_america_climate_zone=="Hot-Humid",]
house <- house[house$in.has_pv == "No",]
#Selecting data of the july month and sampling 50 rows and merging it with the 
#weather data for 1st building
energy_data <- read_parquet(house$details[1])
energy_data <- energy_data[order(energy_data$time),]
energy_data$building_id <- house$bldg_id[1]
energy_data <- energy_data[energy_data$time >= as.POSIXct("2018-07-01") &
                             energy_data$time <= as.POSIXct("2018-07-31 23:00:00"),]
energy_data <- energy_data[as.numeric(format(energy_data$time, "%H")) >= 14&
                             as.numeric(format(energy_data$time, "%H")) <= 18,]
energy_data <- na.omit(energy_data)
weather_data <- read_csv(house$weather_data[1])
energy_data <- merge(x=energy_data, y=weather_data, by.x = "time", by.y = "date_time")
#View(energy_data)
#Creating a loop to add 5 hours a day for july month from each house to energy data
for(i in 2:nrow(house)){
  energy_data1 <- read_parquet(house$details[i])
  energy_data1 <- energy_data1[order(energy_data1$time),]
  energy_data1$building_id <- house$bldg_id[i]
  energy_data1 <- energy_data1[energy_data1$time >= as.POSIXct("2018-07-01") &
                               energy_data1$time <= as.POSIXct("2018-07-31 23:00:00"),]
  energy_data1 <- energy_data1[as.numeric(format(energy_data1$time, "%H")) >= 14 &
                               as.numeric(format(energy_data1$time, "%H")) <= 18,]
  energy_data1 <- na.omit(energy_data1)
  weather_data <- read_csv(house$weather_data[i])
  energy_data1 <- merge(x=energy_data1, y=weather_data, by.x = "time", by.y = "date_time")
  energy_data <- rbind(energy_data,energy_data1)
}
View(energy_data)
View(df)
df$hour <- as.numeric(format(energy_data1$time, "%H"))
#write.csv(df,"combined_house_data.csv",row.names = FALSE)
