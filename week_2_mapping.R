# Set up ----
setwd("~/Year 3/Cartography and Data Visualisation/Week 2 Blog Post")

# Map for distribution of funds ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('prevention_grant_allocation_for_23_24', style = 'quantile', palette = 'Greens',
          title = "(£) Quantile", 
          na.rm = TRUE) +
  tm_borders(col = "grey", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Homelessness Prevention Grant Allocations in England (2023-2024)",
            main.title.size = 1.2,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            asp = 1) +
  tm_credits("Created using Local Authority level data\nfrom the Department for Levelling Up, Housing and Communities (2022)\nand the Ministry of Housing, Communities & Local Government (2023)", 
             position = c("right", "bottom"),
             align = "right",
             size = 0.65)
tmap_save(FundMap, filename = "homelessness_prevention_allocation_map.png", width = 300, height = 200, units = "mm", dpi = 300)

# Map for allocation per thousand homeless households ----
FundMap <- tm_shape(uk_homelessness) +
  tm_fill('allocation_per_thousand_homeless_households', style = 'quantile', palette = 'Blues',
          title = "(£) Quantile", 
          na.rm = TRUE) +
  tm_borders(col = "grey", lwd = 0.2) +
  tm_layout(frame = FALSE,
            main.title = "Grant Allocation Per Thousand Homeless Households in England (2023-2024)",
            main.title.size = 1.1,
            legend.outside = FALSE,
            legend.position = c("left", "center"),
            asp = 1) +
  tm_credits("Created using Local Authority level data\nfrom the Department for Levelling Up, Housing and Communities (2022)\nand the Ministry of Housing, Communities & Local Government (2023)", 
             position = c("right", "bottom"),
             align = "right",
             size = 0.65)
tmap_save(FundMap, filename = "per_thousand_homeless_households_map.png", width = 300, height = 200, units = "mm", dpi = 300)
