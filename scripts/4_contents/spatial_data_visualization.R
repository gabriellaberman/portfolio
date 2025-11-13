### map of bycatch captures from the WCPFC observer data

# load libraries
library(ggspatial)
library(rnaturalearth)
library(tidyverse)
library(sf)
library(terra)
library(tidyterra)
library(mapview)

# load data
longline_vect <- vect("processed_data/longline.gpkg") # import as a spatvector
coast <- ne_countries() |>  # countries and their coastlines
  st_break_antimeridian(lon_0 = 150) |> 
  filter(!name == "Antarctica") # filter Antarctica so the map projects correctly

# rasterize data (convert from spatvector to spatraster and from sf to spatraster)
  # template raster for more control over specifications
template <- rast(ext(longline_vect), resolution = 5, crs = crs(longline_vect))
  # convert to raster
longline_raster <- rasterize(longline_vect, template, field = "captures", fun = sum) |> 
  project("EPSG:8859") # reproject the raster data to center the pacific

#reproject coast 
coast_reproject <- st_transform(coast, crs = "EPSG:8859") 

# visualize data
captures_rast <- 
  ggplot() +
  geom_spatraster(data = longline_raster) +
  scale_fill_viridis_c(name = "Captures", 
                       na.value = "transparent",
                       option = "plasma") +
  geom_sf(data = coast_reproject, 
          fill = NA, 
          color = "black", 
          linewidth = 0.5) +
  annotation_north_arrow(location = "tr") +
  annotation_scale(location = "br") +
  labs(title = "Longline bycatch captures",
       caption = "Longline bycatch captures for 2013-2024 from the WCPFC bycatch observer data, scale bar may be innacurate for some parts of the map due to mercator projection") +
  coord_sf(crs = "+proj=merc +lon_0=150 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +type=crs") + # mercator projection
  theme_classic()
  
# export map
ggsave("results/img/captures_rast.png", plot = captures_rast, height = 8, width = 10)
