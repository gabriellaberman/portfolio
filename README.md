# portfolio
Class portfolio for EVR 628, fall 2025.

# this r project will be updated through the semester

# Assignment 1: Data Wrangling

  project objective: Clean the WCPFC's publically available observer dataset for bycatch.
  The dataset was stored in an excel file with several different tabs.
  I imported the tabs individually, combined them, and then cleaned the dataset and put it into tidy format.
  
  project repository contents: 
    .gitignore
    .Rhistory
    original_downlads
    Rproj
    processed_data
    README.md
    scripts
  
  columns: longline.gpkg
    year: (num) year that the data was collected by the observers
    species_code: (chr) three letter code for the common name or group
    species_category: (chr) whether the animal is a shark, mammal, bird, or turtle
    sci_name: (chr) animal's scientific name (or genus when species was not possible to identify)
    common_name: (chr) animal's common name or group
    vessels: (num) number of vessels from which the observer data was collected
    captures: (num) number of animal captured in longline hooks
    capture_rate: (num) rate of captures per 1000 hooks
    mortalities: (num) number of mortalities from longline gear
    mortality_rate: (num) rate of mortality per 1000 hooks
    live_releases: (num) number of animals released from longline gear
    geom: (sfc) lat/lon coordinates at 5x5 degree resolution

  columns: purse_seine.gpkg
    year: (num) year that the data was collected by the observers
    species_code: (chr) three letter code for the common name or group
    species_category: (chr) whether the animal is a shark, mammal, bird, or turtle
    sci_name: (chr) animal's scientific name (or genus when species was not possible to identify)
    common_name: (chr) animal's common name or group
    vessels: (num) number of vessels from which the observer data was collected
    sets: (num) number of purse seines set
    interactions: (num) number of interactions with purse seine sets
    interaction_rate: (num) rate of interactions per purse seine set
    mortalities: (num) number of mortalities from purse seine gear
    mortality_rate: (num) rate of mortalities per purse seine set
    live_releases: (num) number of animals released from purse seine gear
    geom: (sfc) lat/lon coordinates at 5x5 degree resolution
    
  columns: full_ll.csv
    year: (num) year the data was collected
    fishery: (chr) in this case it is "L" for longline
    total_effort: (num) WCPFC metadata is not clear on what this column is measurin
    total_observed_effort: (num) WCPFC metadata is not clear on what this column is measurin
    observer_coverage: (num) percent of fleet with observers on board
    
  columns: full_ps.csv
    year: (num) year the data was collected
    fishery: (chr) in this case it is "S" for purse seine
    total_effort: (num) WCPFC metadata is not clear on what this column is measuring
    total_observed_effort: (num) WCPFC metadata is not clear on what this column is measurin
    observer_coverage: (num) percent of fleet with observers on board
    
  
Link to final rendered document: https://gabriellaberman.github.io/portfolio/