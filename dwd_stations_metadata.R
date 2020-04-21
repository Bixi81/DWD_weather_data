
library(rvest)
library(tidyverse)
library(dplyr)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Peter Heindl
# April 2020
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Download DWD weather stations meta data from URL below and save as DF

page <- read_html("https://www.dwd.de/DE/leistungen/klimadatendeutschland/statliste/statlex_html.html?view=nasPublication&nn=16102")

table_text <- page %>%
  html_nodes("table") %>%
  html_nodes("td") %>%
  html_text()

table_matrix <- matrix(table_text, ncol = 11, byrow = TRUE)
stations = data.frame(table_matrix)

colnames(stations)<-c("name","STATIONS_ID","mtype","stationskennung","lat","lon","height","flussgebiet","state","start","end")
rm(page,table_matrix,table_text)

# Distinct by ID
stations=stations %>% 
  distinct(STATIONS_ID, .keep_all = T)
