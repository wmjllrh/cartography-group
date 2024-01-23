# Set up ----
setwd("~/Year 3/Cartography and Data Visualisation/Week 2 Blog Post")

# Libraries used ----
library(readODS)
library(httr)
library(dplyr)
library(sf)

# Downloading the homelessness april to june 2023 data ----
url <- "https://assets.publishing.service.gov.uk/media/65804b111c0c2a001318cf6d/Detailed_LA_202306_All_Dropdowns_Fixed.ods"

# Temporary file to store the downloaded ODS file
temp_file <- tempfile(fileext = ".ods")

# Download the file
GET(url, write_disk(temp_file, overwrite = TRUE))

# Reading the relevant sheet into a dataframe
homeless_apr_jun_23 <- read_ods(temp_file, sheet = "A1")

# Downloading the homelessness prevention grant allocation data (2023-2025) ----
url <- "https://assets.publishing.service.gov.uk/media/63a1880dd3bf7f37654767a3/Homelessness_Prevention_Grant_2023_to_2025_allocations.ods"

# Temporary file to store the downloaded ODS file
temp_file <- tempfile(fileext = ".ods")

# Download the file
GET(url, write_disk(temp_file, overwrite = TRUE))

# Storing the data in a dataframe
prevention_grant_allocations_23_25 <- read_ods(temp_file)

# Removing unnessary files
rm(temp_file)
rm(url)

# Loading UK 2021 shapefile data ----
url <- "https://open-geography-portalx-ons.hub.arcgis.com/datasets/ons::local-authority-districts-may-2021-uk-bgc-1.zip?where=1=1&outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D"

# Downloading the ZIP file
download.file(url, destfile = "local_authority_districts.zip")

# Unzip the file
unzip("local_authority_districts.zip", exdir = "local_authority_districts")

UK_shape <- read_sf("local_authority_districts", "LAD_MAY_2021_UK_BGC")

# Subsetting to only include England
England_shape <- UK_shape %>%
  filter(grepl("^E", LAD21CD))

# Cleaning homelessness april to june 2023 data ----
# Setting row 4 as column headers
colnames(homeless_apr_jun_23) <- as.character(unlist(homeless_apr_jun_23[4, ]))

# Removing unncessary upper rows
homeless_apr_jun_23 <- homeless_apr_jun_23[-(1:10), ]

# Only retaining columns of interest
homeless_apr_jun_23_subset <- homeless_apr_jun_23[,c(1:2, 14, 16)]

# Renaming columns
names (homeless_apr_jun_23_subset) [1:4] <- c("LA_code",
                               "LA_name",
                               "households_in_area_in_thousands",
                               "households_assessed_as_homeless_per_000")

# Cleanining remaining rows
homeless_apr_jun_23_subset <- homeless_apr_jun_23_subset %>%
  # Remove rows where the first column is NA
  filter(!is.na(homeless_apr_jun_23_subset$LA_code)) %>%
  # Assign NA to non-numeric values in the fourth column
  mutate(households_assessed_as_homeless_per_000 = ifelse(!is.na(as.numeric(households_assessed_as_homeless_per_000)), households_assessed_as_homeless_per_000, NA))

# Checking structure 
str(homeless_apr_jun_23_subset)

# Converting columns to numeric
homeless_apr_jun_23_subset <- homeless_apr_jun_23_subset %>%
  mutate(households_assessed_as_homeless_per_000 = as.numeric(as.character(households_assessed_as_homeless_per_000))) %>%
  mutate(households_in_area_in_thousands = as.numeric(as.character(households_in_area_in_thousands)))

# Checking for any remaining unexpected values
table(homeless_apr_jun_23_subset$LA_code)
table(homeless_apr_jun_23_subset$LA_name)

# Remvoing notes etc:
homeless_apr_jun_23_subset <- homeless_apr_jun_23_subset %>%
  filter(!LA_code %in% c('Notes', 'Source', '..', '1', '2', '3', '4', '5'))

# Checking again 
table(homeless_apr_jun_23_subset$LA_name)
table(homeless_apr_jun_23_subset$LA_code)

# Adding variable to indicate actual number of homeless households in an area
homeless_apr_jun_23_subset$homeless_households_actual_in_thousands <- homeless_apr_jun_23_subset$households_assessed_as_homeless_per_000 * homeless_apr_jun_23_subset$households_in_area_in_thousands

# Cleaning prevention grant data ----
# Setting row 1 as column headers
colnames(prevention_grant_allocations_23_25) <- as.character(unlist(prevention_grant_allocations_23_25[1, ]))

# Removing unnecessary upper rows
prevention_grant_allocations_23_25 <- prevention_grant_allocations_23_25[-(1), ]

# Only retaining columns of interest
prevention_grant_allocations_23_25_subset <- prevention_grant_allocations_23_25[,c(1:3)]

# Renaming columns
names (prevention_grant_allocations_23_25_subset) [1:3] <- c("LA_code",
                                              "LA_name",
                                              "prevention_grant_allocation_for_23_24")

# Cleaning remaining rows
prevention_grant_allocations_23_25_subset <- prevention_grant_allocations_23_25_subset %>%
  # Remove rows where the second column is NA
  filter(!is.na(prevention_grant_allocations_23_25_subset$LA_name)) %>%
  # Assign NA to non-numeric values in the third column
  mutate(prevention_grant_allocation_for_23_24 = ifelse(!is.na(as.numeric(prevention_grant_allocation_for_23_24)), prevention_grant_allocation_for_23_24, NA))

# Checking structure 
str(prevention_grant_allocations_23_25_subset)

# Converting the households prevention grant column to numeric
prevention_grant_allocations_23_25_subset <- prevention_grant_allocations_23_25_subset %>%
  mutate(prevention_grant_allocation_for_23_24 = as.numeric(as.character(prevention_grant_allocation_for_23_24)))

# Checking for any remaining unexpected values
table(prevention_grant_allocations_23_25_subset$LA_code)
table(prevention_grant_allocations_23_25_subset$LA_name)

# Combined data----
# Merging the data:
homelessness_merged_data <- merge (homeless_apr_jun_23_subset, prevention_grant_allocations_23_25_subset,
                     by.x = "LA_code",
                     by.y = "LA_code") 

# Adding a new variable to indicate actual funds per homeless household (in thousands)
homelessness_merged_data$allocation_per_thousand_homeless_households <- homelessness_merged_data$prevention_grant_allocation_for_23_24 / homelessness_merged_data$homeless_households_actual_in_thousands

# Left joining homelessness data to the UK shapefile
uk_homelessness <- merge(England_shape,
                         homelessness_merged_data,
                         by.x = "LAD21CD",       
                         by.y = "LA_code",          
                         all.x = TRUE)              

# Handling created infinite values
uk_homelessness$allocation_per_thousand_homeless_households[is.infinite(uk_homelessness$allocation_per_thousand_homeless_households)] <- NA