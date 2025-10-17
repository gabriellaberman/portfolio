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
    
  columns:
    year: (num) year that the data was collected by the observers
    fishery: (char) longline or purse seine 
    vessels: (num) number of vessels from which the observer data was collected
    captures: (num) number of animal captured in longline hooks
    captures_per_1000_hooks: (num) rate of capture per 1000 hooks
    mortalities_per_1000_hooks: (num) rate of mortality per 1000 hooks
    sets: (num) number of purse seines set
    interactions: (num) number of interactions with purse seine sets
    interactions_per_set: (num) rate of interactions per purse seine set
    mortalities_per_set: (num) rate of mortalities per purse seine set
    live_releases: (num) number of animals released from either longline or purse seine gear
    mortalities: (num) number of mortalities from either longline or purse seine gear
    sci_name: (char) animal's scientific name (or genus, or group when species was not possible to identify)
    common_name: (char) animal's common name or group
    code: (char) three letter code for the common name or group
    geom: (sfc) lat/lon coordinates at 5x5 degree resolution