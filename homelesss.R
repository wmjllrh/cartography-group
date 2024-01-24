homelessness <- read.csv("Homeless.csv")
View(homelessness)

#load packages to read shapefile
library("sf")
library("httr")
library("dplyr")
library("tm")
library("tmap")
library("sp")

# Cleaning homelessness april to june 2023 data ----
# Setting row 4 as column headers
colnames(homelessness) <- as.character(unlist(homelessness[4, ]))

# Removing unncessary upper rows
homelessness <- homelessness[-c(1:20, 317:371),]
# Only retaining columns of interest
homelessness <- homelessness[,c(1:2,16)]

# Renaming columns
names(homelessness)[1:3] <- c("LA_code","LA_name","households_assessed_as_homeless_per_000")
View(homelessness)

# Cleanining remaining rows
homelessness_subset <- homelessness %>%
  # Remove rows where the first column is NA
  filter(!is.na(homelessness$LA_code)) %>%
  # Assign NA to non-numeric values in the fourth column
  mutate(households_assessed_as_homeless_per_000 = ifelse(!is.na(as.numeric(households_assessed_as_homeless_per_000)), 
                                                                 households_assessed_as_homeless_per_000, NA))

View(homelessness_subset)

# Checking structure 
str(homelessness_subset)

# Converting columns to numeric
homelessness_subset <- homelessness_subset %>%
  mutate(households_assessed_as_homeless_per_000 = as.numeric(as.character(households_assessed_as_homeless_per_000))) 
  
# Checking for any remaining unexpected values
table(homelessness_subset$LA_code)
table(homelessness_subset$LA_name)

# Remvoing notes etc:
homelessness_subset <- homelessness_subset %>%
  filter(!LA_code %in% c('Notes', 'Source', '..', '1', '2', '3', '4', '5')) %>%
  filter(!LA_name %in% c(''))

# Checking again 
table(homelessness_subset$LA_name)
table(homelessness_subset$LA_code)

#loading UK shapefile 2023
UK_shape <- read_sf(
  "local authority districts", "LAD_MAY_2023_UK_BGC_V2")

# Subsetting to only include England
England_shape <- UK_shape %>%
  filter(grepl("^E", LAD23CD))
View(England_shape)

#merge tge two datasets
homelessness.England <- merge(England_shape, homelessness_subset, by.x="LAD23CD", by.y="LA_code", all.x=TRUE)

#loading packages to quick map
library(tmap)
library(leaflet)

#quick map for homelessness
qtm(homelessness.England, fill = "households_assessed_as_homeless_per_000")

tm_shape(homelessness.England) + tm_fill("households_assessed_as_homeless_per_000", 
                                         style = "quantile", 
                                         palette = "Reds")

HomelessMap <- tm_shape(homelessness.England) +
  tm_fill('households_assessed_as_homeless_per_000', style = 'quantile', palette = 'Reds',
          title = "Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "white", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Households assessed as homeless per 1,000 in England (2023)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            legend.text.size = 1.5,
            legend.title.size = 1.5,
            asp = 1,
            main.title.fontface = 'bold') +
  tm_credits("Created using Local Authority level data\nfrom the Department for Levelling Up, Housing and Communities (2022)\nand the Ministry of Housing, Communities & Local Government (2023)", 
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(HomelessMap, filename = "histogram_homelessness_rates_in_England.png", width = 300, height = 300, units = "mm", dpi = 300)
