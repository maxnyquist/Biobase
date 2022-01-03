################################### HEADER ###################################
#   TITLE: biobase_csv_process.R
#   DESCRIPTION: Reads .csv file from biobasemaps.com in W drive directory for initial QA/QC. This file is then passed to ArcPro for further processing into map/tile package
#   AUTHOR(S): Max Nyquist
#   DATE LAST UPDATED: 1/3/2022
#   R VERSION 4.0.3
##############################################################################.

### LOAD PACKAGES ####
pkg <- c("tidyverse", "magrittr", "lubridate","RODBC", "DBI", "odbc")
sapply(pkg, library, character.only = TRUE)

### SET OPTIONS/ENV VARIABLES ####

### Eliminate Scientific Notation
  options(scipen = 999)

### SOURCE DATA/FUNCTIONS/FILES ####
# 
# R_Config <- read.csv("//env.govt.state.ma.us/enterprise/DCR-WestBoylston-WKGRP/WatershedJAH/EQStaff/WQDatabase/R-Shared/Code/R_Config.csv", header = TRUE)
# config <- as.character(R_Config$CONFIG_VALUE)

biobase_dir <- "W:/WatershedJAH/EQStaff/Aquatic Biology/GIS/ciBiobase_sl2"
### Annual Data 
### change this folder each year when new data arrives  
### Update with new Year 
biobase_year <- paste0(biobase_dir, "/2021")
biobase_raw <- paste0(biobase_year, "/raw from biobase")
biobase_processed <- paste0(biobase_year, "/processed csv")
### Run after downloading from biobasemaps.com 
csv_files <- list.files(biobase_raw,full.names = TRUE, pattern = "\\.csv$")
csv_files
### Manually update with file to be processed
csv_in <- c(11)
csv_files <- csv_files[csv_in]
data <- lapply(csv_files, read_csv)
df_name <- gsub(".csv", "", list.files(biobase_raw, pattern = "\\.csv$"))
df_name <- df_name[csv_in]
names(data) <- df_name
names(data) <- 'df'
list2env(data,.GlobalEnv)

rm(data)
rm('NA')

### Need to put in a loop/funciton to go through each one of these not in the "processed" folder  

### SCRIPT BEGIN ####
for (i in data)
{select(i)}
  
  
df <- df %>% 
    select(4:7)
df$BioVolume[df$BioVolume < 0.001] <- 0

csv_name <- paste0(biobase_processed,"/", df_name,"_processed", ".csv")

write_csv(df, csv_name)


  
  
