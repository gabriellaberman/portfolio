## clean wcpfc public domain observer bycatch data 

# load libraries
library(here)
library(tidyverse)
library(readxl)
library(janitor)
library(sf)

# load data, organize, & clean names
sheet1 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx", # observer coverage (BDEP and full observer database)
                    sheet = 1,
                    na = "na",
                    col_names = FALSE) |> 
  slice(-14) |> # delet row 14 because its empty
  slice(-1) |> # delete row 1
  row_to_names(row_number = 1) |> # set row 1 as column names
  clean_names() 

full_ll <- sheet1[, 8:12] |> # separate the full table from the bdep table
  slice(1:11) |> # longline data from top half of sheet
  mutate(calendar_year_2 = as.numeric(calendar_year_2)) # convert calendar_year_2 from char to num
  
full_ps <- sheet1[, 8:12] |> # separate the full table from the bdep table
  slice(12:22) |> # purse seine data from bottom half of sheet
  mutate(calendar_year_2 = as.numeric(calendar_year_2)) # convert calendar_year_2 from char to num

sheet4 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx", # longline
                    sheet = 4,
                    na = "na") |> 
  clean_names() |> 
  mutate(calendar_year = as.numeric(calendar_year))

sheet5 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx", # purse seine
                    sheet = 5,
                    na = "na") |> 
  clean_names() |> 
  mutate(calendar_year = as.numeric(calendar_year))

sheet6 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx", # species
                    sheet = 6,
                    na = "na") |> 
  clean_names() |> 
  pivot_longer(cols = c(bdep_wcpfc_species_grouping, common_name),
               names_to = NULL,
               values_to = "common_name") |> 
  distinct() # only keep distinct rows

# join longline (sheet4) and species sheets (sheet6), convert lat lon to geom, rename columns
longline <-
  left_join(x = sheet4,
            y = sheet6,
            by = join_by(species_category == species_category,
                         species_or_group == common_name)) |> 
  st_as_sf(coords = c("latitude_5_cell", "longitude_5_cell"), crs = 4326) |> # convert lat lon to geom
  mutate(species_or_group = str_to_lower(species_or_group),
         scientific_name = str_to_sentence(scientific_name)) |> 
  select(year = calendar_year,
         species_code,
         species_category,
         sci_name = scientific_name,
         common_name = species_or_group,
         vessels = number_of_vessels_with_observer_data,
         captures = observed_captures_number,
         capture_rate = observed_capture_rate_per_1000_hooks,
         mortalities = observed_mortalities_number,
         mortality_rate = observed_mortality_rate_per_1000_hooks,
         live_releases = observed_live_releases) 

  
# join longline (sheet5) and species sheets (sheet6), convert lat lon to geom, rename columns
purse_seine <- 
  left_join(x = sheet5,
            y = sheet6,
            by = join_by(species_category == species_category, 
                         species_or_group == common_name)) |> 
  st_as_sf(coords = c("latitude_5_cell", "longitude_5_cell"), crs = 4326) |> # convert lat lon to geom
    mutate(species_or_group = str_to_lower(species_or_group),
         scientific_name = str_to_sentence(scientific_name)) |> 
  select(year = calendar_year,
         species_code,
         species_category,
         sci_name = scientific_name,
         common_name = species_or_group,
         vessels = number_of_vessels_with_observer_data,
         sets = number_of_sets_observed,
         interactions = observed_interactions_number,
         interaction_rate = observed_interaction_rate_per_set,
         mortalities = observed_mortalities_number,
         mortality_rate = observed_mortality_rate_per_set,
         live_releases = observed_live_releases)

# export to disk
st_write(obj = longline,
         dsn = here("processed_data/longline.gpkg"),
         delete_dsn = TRUE)

st_write(obj = purse_seine,
         dsn = here("processed_data/purse_seine.gpkg"),
         delete_dsn = TRUE)

write.csv(full_ll, "processed_data/full_ll.csv", row.names = FALSE)

write.csv(full_ps, "processed_data/full_ps.csv", row.names = FALSE)
