# Client: University of Lucerne
#
# Project: Complaints
#-------------------------------------------------------------------------#

options(digits=4)
rm(list = ls())

install.packages(c("dplyr", "tidyr"))

library(tidyr);library(dplyr);library(ggplot2);

#-------------------------------------------------------------------------#
# Parameters
#-------------------------------------------------------------------------#

#-- Path

filename_data  <- "complaints.csv"

#--------------------------------------------------------------------------
#-- Load data
#--------------------------------------------------------------------------

data <- read.csv(paste0(filename_data))

#-------------------------------------------------------------------------#
# First Impression
#-------------------------------------------------------------------------#

# look at first 20 rows
View(data[ 1:20 , ])

# names of all character columns/ numeric columns
names(as.data.frame(data  %>% dplyr::select(where(is.character))))
names(as.data.frame(data  %>% dplyr::select(where(is.numeric))))

# missing data 

# 1. Handling missing values
# Replace missing values in character columns with "Unknown"
data <- data %>%
  mutate(across(where(is.character), ~if_else(is.na(.), "Unknown", .)))

# Replace missing values in numeric columns with mean value
data <- data %>%
  mutate(across(where(is.numeric), ~if_else(is.na(.), mean(., na.rm = TRUE), .)))

# Add a new column "Number_of_records" with a value of 1
data$Number_of_records <- 1

# Change column names
names(data)[names(data) == "Date.received"] <- "Date Received"
names(data)[names(data) == "Date.sent.to.company"] <- "Date Sent to Company"

# Convert to date format (assuming the original date format is "year-month-day")
data$`Date Received` <- as.Date(data$`Date Received`, format = "%Y-%m-%d")
data$`Date Sent to Company` <- as.Date(data$`Date Sent to Company`, format = "%Y-%m-%d")

# Calculate the difference in days between Date Received and Date Sent to Company
data$Average_No_days <- as.numeric(data$`Date Sent to Company` - data$`Date Received`)

# Find the average days to sent to company
average_days <- mean(data$Average_No_days, na.rm = TRUE)

# Filter the dataset to include only the rows where dates are from years 2022, 2023, and 2024
#data <- data[data$`Date Received` >= as.Date("2022-01-01") & data$`Date Received` <= as.Date("2024-12-31"), ]
#data <- data[data$`Date Sent to Company` >= as.Date("2022-01-01") & data$`Date Sent to Company` <= as.Date("2024-12-31"), ]


# Write the updated data frame back to a CSV file
write.csv(data, "data_prep.csv", row.names = FALSE)