#############################################
# NRRI Hg Incubation Geochem Figures
# Name: Matthew Berens
# Updated: 9/2/2025
#############################################

#Load libraries and set directory
library(dplyr)
library(magrittr)
library(ggplot2)
library(tidyr)
library(ggpmisc)

source("code/0-plotThemes.R")

cleanWQ = readRDS("data/clean/cleanVWINwq.rds")


#Methylation Rates--------------------------------------------
cleanWQ %>%
  filter(parameter == "pH") %>%
  filter(value > 0) %>%
  ggplot(aes(x = month, y = value)) +
  stat_summary(aes(group = waterYear, fill = waterYear), geom = "point",
               fun = "mean", shape = 21, color = "black", size = 3) +
  facet_grid(~site.number) +
  scale_fill_distiller(palette = "Spectral") +
  theme_mb1()


#Methylation Extent--------------------------------------------
cleanWQ %>%
  filter(parameter == "NH3N") %>%
  filter(value > 0) %>%
  ggplot(aes(x = waterYear, y = value)) +
  stat_summary(aes(group = site.number, fill = site.number), geom = "point",
               fun = "mean", shape = 21, color = "black", size = 3) +
  #facet_grid(~site.number) +
  scale_fill_brewer(palette = "Spectral") +
  theme_mb1()

