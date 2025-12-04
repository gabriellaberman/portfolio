## assignment 3 - visualizng the data

# load libraries 
library(tidyverse)
library(ggplot2)
library(here)
library(scales)
library(sf)
library(cowplot)

# load data
longline <- st_read(dsn = here("processed_data/longline.gpkg"))
purse_seine <- st_read(dsn = here("processed_data/purse_seine.gpkg"))

full_ll <- read_csv("processed_data/full_ll.csv")
full_ps <- read_csv("processed_data/full_ps.csv")

# inspect data
glimpse(longline)
glimpse(purse_seine)
glimpse(full_ll)
glimpse(full_ps)

# build figure 1: compare mortalities by species category turtle, shark, marine mammal, or bird for the longline and puirse seine vessels
  # build plot for the longline vessels
p1 <- ggplot(data = longline,
             mapping = aes(fill = species_category,
                           x = mortalities,
                           y = species_category)) +
  geom_violin() + 
  scale_x_log10() +
  theme_classic(base_size = 12) +
  scale_fill_manual(values = c("TTX" = "darkgreen", "SHK" = "lightblue", "MAM" = "purple", "BRD" = "orange")) +
  scale_y_discrete(labels = c("TTX" = "Turtle", "SHK" = "Shark", "MAM" = "Mammal", "BRD" = "Bird")) +
  theme(axis.title.y.left = element_blank(),
        legend.position = "none") +
  labs(x = element_blank(),
       title = "Mortalities by animal type") 
  #build plot for the purse siene vessels
p2 <- ggplot(data = purse_seine,
             mapping = aes(fill = species_category,
                           x = mortalities,
                           y = species_category)) +
  geom_violin() + 
  scale_x_log10() +
  theme_classic(base_size = 12) +
  scale_fill_manual(values = c("TTX" = "darkgreen", "SHK" = "lightblue", "MAM" = "purple", "BRD" = "orange")) +
  scale_y_discrete(labels = c("TTX" = "Turtle", "SHK" = "Shark", "MAM" = "Mammal", "BRD" = "Bird")) +
  theme(axis.title.y.left = element_blank(),
        legend.position = "none") +
  labs(x = "Number of mortalities",
       caption = "Bycatch mortalities for 2013-2023 from WCPFC observer data, *note that there are no recorded bird mortalities in the purse seine data")

  #combine the plots using cowplot
animal_type_mortalities <- plot_grid(p1, p2, ncol = 1,
                                     labels = c("Longline", "Purse Seine"),
                                     label_size = 8, 
                                     label_x = 0.95,
                                     label_y = 0.95,
                                     hjust = 1)

# build figure 2: observer coverage by year for purse seine and longline fisheries
observer <- bind_rows(full_ll, full_ps) # combine longline and purse seine observer datasets

  # build the plots
observer_coverage_by_year <- ggplot (data = observer,
                                     mapping = aes(x = year,
                                                   y = observer_coverage)) +
  geom_bar(stat = "identity",
           fill = "darkblue") +
  geom_text(aes(label = percent(observer_coverage)),
            vjust = -0.5,
            size = 3) +
  facet_wrap(~fishery, ncol = 1, 
             scales = "fixed",
             labeller = labeller(fishery = c("L" = "Longline", "S" = "Purse seine"))) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(x = "Year",
       y = "Observer coverage",
       title = "Observer coverage by year",
       caption = "WCPFC's observer coverage by year for longline and purse seine fisheries") +
  theme_classic()

# export visualizations 
ggsave("results/img/animal_type_mortalities.png", plot = animal_type_mortalities, height = 8, width = 10)

ggsave("results/img/observer_coverage_by_year.png", plot = observer_coverage_by_year, height = 8, width = 10)
