library(data.table)
library(lubridate)

trip_data <- fread('trip_data.csv')
weather <- fread('weather.csv')

weather_by_date <- weather[,list(temp=mean(temp),
                                  temp_sd=sd(temp),
                                  rain_3h=sum(rain_3h),
                                  rain_6h=sum(rain_6h)),
                                  by=date]

trip_by_date <- trip_data[, list(rides=.N), by=CheckoutDateLocal]

trip_by_hour <- trip_data[, list(rides=.N), by=list(CheckoutDateLocal, CheckoutHourLocal)]


# Trip weather by date
setkey(weather_by_date,date)
setkey(trip_by_date,CheckoutDateLocal)
trip_weather_by_date <- weather_by_date[trip_by_date, nomatch=0]

# Sub sample to 2017 and onward - twbd_2017
twbd_2017 <- trip_weather_by_date[date > "2017-01-01", ]
twbd_2017[, rain_bool := rain_6h > 0.25]
twbd_2017[, rain_bool := factor(rain_bool, labels=c("No Rain", "Rain"))]

fwrite(twbd_2017, 'twbd_2017.csv')

# Merge hourly with trips
setkey(weather, date, hour)
setkey(trip_by_hour, CheckoutDateLocal, CheckoutHourLocal)

trip_weather_by_hour <- weather[trip_by_hour, nomatch=0]

twbh_2017 <- trip_weather_by_hour[date > "2017-01-01", ]
twbh_2017[, rain_bool := rain_6h > 0.25]
twbh_2017[, rain_bool := factor(rain_bool, labels=c("No Rain", "Rain"))]

fwrite(twbh_2017, 'twbh_2017.csv')

rm(list=ls())
