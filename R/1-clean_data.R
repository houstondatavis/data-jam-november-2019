# Load libraries
library(dplyr)
library(jsonlite)

# Read in revenue data
rev <- read.csv("revenue_details.csv", stringsAsFactors = FALSE)

# Read in trip data
trips <- read.csv("trip_data.csv", stringsAsFactors = FALSE)

# Filter
trips <- trips %>%
  filter(CheckoutKioskName != "" & ReturnKioskName != "") %>%
  filter(DurationMins > 1) %>%
  filter(UserRole != "Maintenance") 

# Nodes
stations <- unique(c(trips$CheckoutKioskName, trips$ReturnKioskName))

data.frame(
    id = stations,
    group = 1
  ) %>%
  jsonlite::toJSON(auto_unbox=T) %>% 
  write("nodes-data.json")

# Links
test <- trips %>%
  group_by(CheckoutKioskName, ReturnKioskName) %>%
  summarise(
    num_trips = n(),
    dist_traveled = sum(Distance),
    carbon_saved = sum(EstimatedCarbonOffset),
    calories_burned = sum(EstimatedCaloriesBurned),
    time_traveled = sum(DurationMins)
  ) %>%
  rename(
    source = CheckoutKioskName,
    target = ReturnKioskName
  ) %>%
  select(source, target, num_trips) %>%
  filter(num_trips >= 10) %>%
  jsonlite::toJSON(auto_unbox=T) %>% 
  write("links-data.json")

