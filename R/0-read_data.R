library(data.table)


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
file_paths <- grep("2013", file_paths, value=T)
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

trip_data <- rbind(pre_change, post_change, fill=TRUE)

fwrite(trip_data, 'trip_data.csv')

#file_paths <- list.files(path = "src/Revenue Data/Revenue Details By Year",
			 pattern = ".csv",
			 full.names=TRUE)

#revenue_details <- print(do.call(dim, lapply(file_paths, fread)))

#fwrite(revenue_details, 'revenue_details.csv')
