#############################################
# CCRG Get StreamStats data
# Name: Matthew Berens
# Updated: 1/28/2026
#############################################
library(magrittr)
library(dplyr)

# get list of streamstats csv exports
streamstats_path <- list.files(path = "data/streamstats", pattern = "*.csv", full.names = TRUE)

# define function to read in streamstats files
import_streamstats <- function(file_path) {
  
  data <-  read.csv(file_path, header = FALSE)
  
  latitude <- data[4,2]
  longitude <- data[5,2]
  GNIS_id <- data[7,2]
  GNIS_name <- data[8,2]
  
  data <- data[(12:66),c(1,3)] %>%
    
    janitor::row_to_names(row_number = 1) %>%
    rename(parameter.code = 'Parameter Code') %>%
    tidyr::pivot_wider(names_from = parameter.code, values_from = Value) %>%
    mutate(site.number = 
             sub("_.*", "", fs::path_ext_remove(basename(file_path)))) %>%
    
    mutate(latitude = latitude,
           longitude = longitude,
           GNIS_id = GNIS_id,
           GNIS_name = GNIS_name) %>%
    
    relocate(site.number, latitude, longitude) %>%
    mutate(across(latitude:SSURGOD, ~ as.numeric(as.character(.)))) %>%
    
    mutate(RELELEV = ELEV - OUTLETELEV)
  
}

# combine all streamstats files into single data frame
vwin.streamstats <- do.call(rbind, lapply(streamstats_path, import_streamstats))

# remove file path and function
rm(streamstats_path, "import_streamstats")


############################################################################
# import vwin site information
vwin.site.data <- read_csv("data/raw/VWIN_site_data.csv") %>%
  
  # select out only the variables of interest
  select(river.basin, water.body, county, site.number) %>%
  
  unique() %>%

  # merge with streamstats information
  merge(vwin.streamstats, by = "site.number")

rm(vwin.streamstats)






