## clean wcpfc public domain bycatch data 

# load libraries
library(here)
library(tidyverse)
library(readxl)
library(janitor)
library(sf)

# load data & clean names
sheet2 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx",
                    sheet = 2,
                    na = "na") |> 
  clean_names()

sheet3 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx",
                    sheet = 3,
                    na = "na") |> 
  clean_names()

sheet4 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx",
                    sheet = 4,
                    na = "na") |> 
  clean_names()

sheet5 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx",
                    sheet = 5,
                    na = "na") |> 
  clean_names()

sheet6 <- read_xlsx("original_downloads/BDEP Tables_11-2024 (1).xlsx",
                    sheet = 6,
                    na = "na") |> 
  clean_names()

# convert lat lon to geom
sheet4_geom <- st_as_sf(sheet4, coords = c("latitude_5_cell", "longitude_5_cell"), crs = 4326)
sheet5_geom <- st_as_sf(sheet5, coords = c("latitude_5_cell", "longitude_5_cell"), crs = 4326)

# show shared columns (to identify which columns to join)
intersect(names(sheet2), names(sheet4_geom)) # sheet2 and sheet4_geom are longline
intersect(names(sheet3), names(sheet5_geom)) # sheet3 and sheet5_geom are purse seine

# join dataframes using full join and specifying column names
longline <- full_join(x = sheet2,
                      y = sheet4_geom,
                      by = c("calendar_year",
                             "fishery",
                             "species_category",
                             "species_or_group",
                             "number_of_vessels_with_observer_data",
                             "observed_captures_number",
                             "observed_capture_rate_per_1000_hooks",
                             "observed_mortalities_number",
                             "observed_mortality_rate_per_1000_hooks",
                             "observed_live_releases"))

purse_seine <- full_join(x = sheet3,
                         y = sheet5_geom,
                         by = c("calendar_year",
                                "fishery",
                                "species_category",
                                "species_or_group",
                                "number_of_vessels_with_observer_data",
                                "number_of_sets_observed",
                                "observed_interactions_number",
                                "observed_interaction_rate_per_set",
                                "observed_mortalities_number",
                                "observed_mortality_rate_per_set",
                                "observed_live_releases"))

# show shared column names
intersect(names(longline), names(purse_seine))

# join longline and purse seine dataframes using full join and specifying column names
ll_ps <- full_join(x = longline,
                   y = purse_seine,
                   by = c("calendar_year",
                         "fishery",
                         "species_category",
                         "species_or_group",
                         "number_of_vessels_with_observer_data",
                         "observed_mortalities_number",
                         "observed_live_releases",
                         "geometry"))

# show shared column names
intersect(names(ll_ps), names(sheet6))

# join the combined longline and purse seine dataframes with sheet6
ll_ps_species <- full_join(x = ll_ps, 
                           y = sheet6,
                           by = c("species_category",
                                  "species_or_group" = "bdep_wcpfc_species_grouping"))

# put data in tidy format using pivot_longer
t1 <- ll_ps_species |>  
  pivot_longer(cols = c(common_name, species_or_group),
               names_to = NULL,
               values_to = "common_name")

t2 <- t1 |> 
  pivot_longer(cols = c(species_category, species_code),
               names_to = NULL,
               values_to = "code")

# rename columns, remove NAs, change capitalization in rows, and reorder columns
wcpfc <- t2 |> 
  replace_na() |> 
  rename(year = calendar_year,
         vessels = number_of_vessels_with_observer_data,
         captures = observed_captures_number,
         captures_per_1000_hooks = observed_capture_rate_per_1000_hooks,
         mortalities = observed_mortalities_number,
         mortalities_per_1000_hooks = observed_mortality_rate_per_1000_hooks,
         live_releases = observed_live_releases,
         geom = geometry,
         sets = number_of_sets_observed,
         interactions = observed_interactions_number,
         interactions_per_set = observed_interaction_rate_per_set,
         mortalities_per_set = observed_mortality_rate_per_set,
         sci_name = scientific_name
         ) |> 
  mutate(common_name = str_to_lower(common_name),
         sci_name = str_to_sentence(sci_name)) |> 
  select(year,
         fishery,
         vessels,
         captures,
         captures_per_1000_hooks,
         mortalities_per_1000_hooks,
         sets,
         interactions,
         interactions_per_set,
         mortalities_per_set,
         live_releases,
         mortalities,
         sci_name,
         common_name,
         code,
         geom)

# change capitalization

# remove NAs

# export to disk
st_write(obj = wcpfc,
         dsn = here("processed_data/wcpfc.gpkg"),
         delete_dsn = TRUE)

