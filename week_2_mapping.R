# Set up ----
setwd("~/Year 3/Cartography and Data Visualisation/Week 2 Blog Post")

options(scipen = 9999)

# Map for distribution of funds ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('prevention_grant_allocation_for_23_24', style = 'quantile', palette = 'Greens',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "black", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Homelessness Prevention Grant Allocations in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            legend.text.size = 1.5,
            legend.title.size = 1.5,
            asp = 1,
            main.title.fontface = 'bold',
            legend.hist.size = 1) +
  tm_credits("*Grant data not available for local authority mergers\n \nData from Ministry of Housing, Communities & Local Government (2023) &\nDepartment for Levelling Up, Housing and Communities (2022)",
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)

# Map for distribution of funds with histogram ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('allocation_per_homeless_household', style = 'quantile', palette = 'Purples',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "black", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Grant Allocation per Homeless Household in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            legend.text.size = 1.5,
            legend.title.size = 1.5,
            asp = 1,
            main.title.fontface = 'bold',
            legend.hist.size = 1.2) +
  tm_credits("*Grant data not available for local authority mergers\n \nData from Ministry of Housing, Communities & Local Government (2023) &\nDepartment for Levelling Up, Housing and Communities (2022)",
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "histogram_homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)

# Map for distribution of funds with labels ----
uk_homelessness <- uk_homelessness %>%
  mutate(label = case_when(
    LAD23CD == 'E07000085' ~ 'East Hampshire: £396,892 allocated for ~9k homeless households', 
    LAD23CD == 'E06000002' ~ 'Middlesbrough: £324,507 allocated for ~256k homeless households', 
    TRUE ~ NA_character_
  ))

FundMap <- tm_shape(uk_homelessness) +
  tm_fill('allocation_per_thousand_homeless_households', style = 'quantile', palette = 'Blues',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "grey", lwd = 0.2) +
  tm_text("label", size = 1, palette = "black") +
  tm_layout(frame = FALSE,
            main.title = "Grant Allocation per Thousand Homeless Households in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            asp = 1,
            main.title.fontface = 'bold') +
  tm_credits("Created using Local Authority level data\nfrom the Department for Levelling Up, Housing and Communities (2022)\nand the Ministry of Housing, Communities & Local Government (2023)", 
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "labelled_homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)# Set up ----
setwd("~/Year 3/Cartography and Data Visualisation/Week 2 Blog Post")

options(scipen = 9999)

# Map for distribution of funds ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('prevention_grant_allocation_for_23_24', style = 'quantile', palette = 'Greens',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "black", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Homelessness Prevention Grant Allocations in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            legend.text.size = 1.5,
            legend.title.size = 1.5,
            asp = 1,
            main.title.fontface = 'bold',
            legend.hist.size = 1) +
  tm_credits("*Grant data not available for local authority mergers\n \nData from Ministry of Housing, Communities & Local Government (2023) &\nDepartment for Levelling Up, Housing and Communities (2022)",
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)

# Map for distribution of funds with histogram ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('allocation_per_thousand_homeless_households', style = 'quantile', palette = 'Purples',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "black", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Grant Allocation per Thousand Homeless Households in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            legend.text.size = 1.5,
            legend.title.size = 1.5,
            asp = 1,
            main.title.fontface = 'bold',
            legend.hist.size = 1.2) +
  tm_credits("*Grant data not available for local authority mergers\n \nData from Ministry of Housing, Communities & Local Government (2023) &\nDepartment for Levelling Up, Housing and Communities (2022)",
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "histogram_homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)

# Map for distribution of funds with labels ----
uk_homelessness <- uk_homelessness %>%
  mutate(label = case_when(
    LAD23CD == 'E07000085' ~ 'East Hampshire: £396,892 allocated for ~9k homeless households', 
    LAD23CD == 'E06000002' ~ 'Middlesbrough: £324,507 allocated for ~256k homeless households', 
    TRUE ~ NA_character_
  ))

FundMap <- tm_shape(uk_homelessness) +
  tm_fill('allocation_per_thousand_homeless_households', style = 'quantile', palette = 'Blues',
          title = "(£) Quantile", 
          na.rm = TRUE,
          legend.hist = T) +
  tm_borders(col = "grey", lwd = 0.2) +
  tm_text("label", size = 1, palette = "black") +
  tm_layout(frame = FALSE,
            main.title = "Grant Allocation per Thousand Homeless Households in England (2023-2024)",
            main.title.size = 1.5,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            asp = 1,
            main.title.fontface = 'bold') +
  tm_credits("Created using Local Authority level data\nfrom the Department for Levelling Up, Housing and Communities (2022)\nand the Ministry of Housing, Communities & Local Government (2023)", 
             position = c("right", "bottom"), fontface = "italic",
             align = "right",
             size = 1) 

tmap_save(FundMap, filename = "labelled_homelessness_prevention_allocation_map.png", width = 300, height = 300, units = "mm", dpi = 300)