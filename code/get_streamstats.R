#############################################
# CCRG Get StreamStats data
# Name: Matthew Berens
# Updated: 1/28/2026
#############################################

# get list of streamstats csv exports
streamstats_path <- list.files(path = "data/streamstats", pattern = "*.csv", full.names = TRUE)


# define function to read in streamstats files
import_streamstats <- function(file_path) {
  data <-  read.csv(file_path, header = TRUE) %>%
    select(-c(Parameter.Description, Unit)) %>%
    pivot_wider(names_from = Parameter.Code, values_from = Value) %>%
    mutate(site.number = 
             sub("_.*", "", path_ext_remove(basename(file_path)))
    )
}

# combine all streamstats files into single data frame
vwin.streamstats <- do.call(rbind, lapply(streamstats_path, import_streamstats)) %>%
  relocate(site.number) %>%
  mutate(RELELEV = ELEV - OUTLETELEV)

# remove file path and function
rm(streamstats_path, "import_streamstats")


   