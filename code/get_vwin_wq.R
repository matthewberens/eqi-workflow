#############################################
# CCRG Proposal Data Wrangling
# Name: Matthew Berens
# Updated: 12/3/2025
#############################################

#Load libraries and set directory
library(dplyr)
library(magrittr)
library(ggplot2)
library(tidyr)
library(lubridate)

#Load data file with sample names
parametersEQI = read.csv("data/raw/EQIparameters.csv")

#Load raw EQI data
rawWQ = read.csv("data/raw/VWIN_wq_data.csv")
rawMACRO = read.csv("data/raw/SMIE_macro_data.csv")


#Prep cleaned EQI data
cleanWQ = rawWQ %>%
  #filter(water.body == "Mud Creek") %>%
  
  #remove erroneous points
  subset(day > 0) %>% 
  
  #get date values
  mutate(date = mdy(paste(month, day, year, sep = "/"))) %>%
  
  #select desired columns
  select(c("site.name", "site.number", "month", "NH3N":"date")) %>%
  
  #remove rows with all NAs
  filter(!if_all(c(NH3N:pH), is.na)) %>%
  
  #convert <RL to NA
  mutate(across(NH3N:pH, as.numeric)) %>%
  
  pivot_longer(NH3N:pH, names_to = "parameter", values_to = "value") %>%
  
  #bring in parameter information
  merge(parametersEQI) %>%
  
  #set <RL to 1/2 of RL
  mutate(value = ifelse(is.na(value), RL/2, value)) %>%
  
  #calculate water year
  mutate(waterYear = ifelse(month(date) >= 10, year(date)+1, year(date)),
         year = year(date)) %>%
  
  #set month to text
  mutate(month = month(date, label = TRUE)) %>%
  
  #set site and month factor levels
  mutate(site.number = factor(site.number, levels = c("H21", "H3", "H18", "H4"))) %>%
  mutate(month = factor(month, levels = c("Oct", "Nov", "Dec", "Jan", "Feb", "Mar",
                                          "Apr", "May", "Jun", "Jul", "Aug", "Sep"))) %>%
  mutate(wday = yday(date)-274,
         jday = yday(date)) %>%
  mutate(wday = ifelse(wday<0, wday+365, wday)) %>%
  select(-c("RL"))

# export cleaned vwin data
saveRDS(cleanWQ, "data/clean/vwin.cleaned.rds")

rm(rawWQ)


#-------------------------------------------------

