library(data.table)
library(lubridate)
library(janitor)


# 2015 to 2019
file_paths <- list.files(path = "src/Trip Data",
			 pattern = ".csv",
			 full.names=TRUE)


file_paths <- grep("201[5-9]", file_paths, value=T)
trip_2015_to_2019 <- do.call(rbind,lapply(file_paths,fread))

# 2013
file_paths <- list.files(path = "src/Trip Data",
			 pattern = ".csv",
			 full.names=TRUE)
file_paths <- grep("201[2-3]", file_paths, value=T)
trip_2013 <- do.call(rbind,lapply(file_paths,fread))


## Special case for 2014
file_paths <- list.files(path = "src/Trip Data",
			 pattern = ".csv",
			 full.names=TRUE)
file_paths <- grep("2014", file_paths, value=T)


pre_schema_change_months <- c("January", "February", "March", "April", "May", "June", "July", "August")

matches <- grep(paste(pre_schema_change_months, collapse="|"), file_paths)
trip_2014_pre_changes <- do.call(rbind,lapply(file_paths[matches],fread))
trip_2014_post_changes <- do.call(rbind,lapply(file_paths[-matches],fread))

post_change <- rbind(trip_2015_to_2019, trip_2014_post_changes)
pre_change <- rbind(trip_2013, trip_2014_pre_changes)

# Standardize column names

pre_change <- clean_names(pre_change)

# Format times and dates for pre change

pre_change[, checkout_date := lubridate::mdy(checkout_date)]
pre_change[, checkout_time := lubridate::hm(checkout_time)]
pre_change[, return_date := lubridate::mdy(return_date)]
pre_change[, return_time := lubridate::hm(return_time)]
pre_change[, checkout_hour := lubridate::hour(checkout_time)]

# Format times and dates for post change
post_change[, CheckoutDateLocal := lubridate::ymd(CheckoutDateLocal)]
post_change[, CheckoutTimeLocal := lubridate::hms(CheckoutTimeLocal)]
post_change[, ReturnDateLocal := lubridate::ymd(ReturnDateLocal)]
post_change[, ReturnTimeLocal := lubridate::hms(ReturnTimeLocal)]
post_change[, CheckoutHourLocal := lubridate::hour(CheckoutTimeLocal)]

# make a null field for pre change
pre_change$blank <- NA

# Set columns in both data sets to match names and order

pre_change_modified <- pre_change[,
c(23,
	23,
	1,
	23,
	23,
	23,
	2,
	23,
	3,
	4,
	23,
	7,
	12,
	17,
	23,
	23,
	23,
	23,
	23,
	23,
	5,
	10,
	6,
	11,
	23,
	23,
	23,
	23,
	22
)]

names(pre_change_modified) <- names(post_change)

# Concatenate pre and post change data sets
trip_data <- rbind(data.frame(pre_change_modified), data.frame(post_change))

# Label e-bikes
trip_data[trip_data$Bike %in% c('15040', '15050', '15052', '15062', '15074', '15056'), "BikeType"] <- "E-Bike"

fwrite(trip_data, 'trip_data.csv')

file_paths <- list.files(path = "src/Revenue Data/Revenue Details By Year",
			 pattern = ".csv",
			 full.names=TRUE)

revenue_details <- do.call(rbind, c(lapply(file_paths, fread), fill=TRUE))

fwrite(revenue_details, 'revenue_details.csv')

weather <- fread('src/Weather Data/5e406040a5e7a080ea1f41c0e37dd96e.csv')

# Clean weather data

## Convert temp to fahrenheit
weather[, temp := temp*1.8+32]
weather[, temp_max := temp_max*1.8+32]
weather[, temp_min := temp_min*1.8+32]

## Adjust time zone
weather[, dt_iso := lubridate::with_tz(lubridate::ymd_hms(dt_iso), "America/Chicago")]
weather[, date := lubridate::date(dt_iso)]

## Convert rainfall to inches
weather$rain_6h[is.na(weather$rain_6h)] <- 0
weather[, rain_6h := rain_6h * 0.0393701]
weather$rain_3h[is.na(weather$rain_3h)] <- 0
weather[, rain_3h := rain_3h * 0.0393701]

# Make hourly weather - hour
weather[, hour := lubridate::hour(weather$dt_iso)]

fwrite(weather, 'weather.csv')

rm(list=ls())

stations <- fread('src/Station Master List.csv')
