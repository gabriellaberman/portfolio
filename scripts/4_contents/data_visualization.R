## assignment 3 - visualizng the data

# load libraries 
library(tidyverse)
library(ggplot2)
library(here)
library(sf)

# load data
wcpfc <- st_read(dsn = here("processed_data/wcpfc.gpkg"))

# inspect data
glimpse(wcpfc)

# build figure 1: compare live releases and mortalities by fishery with a bar chart
ggplot(data = wcpfc,
       mapping = aes(fill = fishery,
                     x = year,
                     y = mortalities)) +
  geom_col() +
  xlim(1, NA) +
  ylim(1, NA) +
  scale_y_log10() +
  scale_x_log10()

#group by year and fishery and then sum by mory and releases, use point


# must factor in the diffyear# must factor in the difference in observer coverage
