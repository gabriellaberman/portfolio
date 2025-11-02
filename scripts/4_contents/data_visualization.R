## assignment 3 - visualizng the data

# load libraries 
library(tidyverse)
library(ggplot2)
library(here)
library(sf)
library(ggridges)

# load data
longline <- st_read(dsn = here("processed_data/longline.gpkg"))
purse_seine <- st_read(dsn = here("processed_data/purse_seine.gpkg"))

# inspect data
glimpse(longline)
glimpse(purse_seine)

# build figure 1: compare mortalities by species category turtle, shark, marine mammal, or bird for the longline fishery
ggplot(data = longline,
       mapping = aes(fill = species_category,
                     x = mortalities,
                     y = species_category)) +
  geom_violin() + 
  scale_x_log10() +
  theme_minimal(base_size = 12) +
  scale_fill_manual(values = c("TTX" = "darkgreen", "SHK" = "lightblue", "MAM" = "purple", "BRD" = "orange")) +
  scale_y_discrete(labels = c("TTX" = "Turtle", "SHK" = "Shark", "MAM" = "Mammal", "BRD" = "Bird")) +
  theme(axis.title.y.left = element_blank(),
        legend.position = "none") +
  labs(x = "Mortalities",
       title = "Mortalities by animal type",
       caption = "Longline bycatch mortalities for 2013-2024 from WCPFC observer data")
  

`# build figure 2: 

ggplot(data = longline,
       mapping = aes(fill = species_category,
                     x = captures,
                     y = live_releases)) +
  geom_line() +
  xlim(1, NA) +
  ylim(1, NA) +
  scale_y_log10() +
  scale_x_log10()


ggplot(data = longline,
       mapping = aes(fill = species_category,
                     x = mortalities,
                     y = species_category)) +
  geom_point(aes(color = species_category)) 




ggplot(data = purse_seine,
       mapping = aes(fill = year,
                     x = observer_coverage,
                     y = total_effort_observed)) +
  geom_point()

ggplot(data = longline,ggtotal_effort_observedplot(data = longline,
       mapping = aes(fill = species_category,
                     x = mortalities,
                     y = species_category)) +
  geom_point()

ggplot(data = longline,
       mapping = aes(x = year,
                     y = observer_coverage)) +
  geom_line()

ggplot(data = purse_seine,
       mapping = aes(x = sets,
                     y = interactions)) +
  geom_point()

ggplot(data = purse_seine,
       mapping = aes(fill = species_category,
                     x = mortalities,
                     y = interactions)) +
  geom_point()

#group by year and fishery and then sum by mory and releases, use point


# must factor in the diffyear# must factor in the difference in observer coverage
