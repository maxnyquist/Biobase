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

R_Config <- read.csv("//env.govt.state.ma.us/enterprise/DCR-WestBoylston-WKGRP/WatershedJAH/EQStaff/WQDatabase/R-Shared/Code/R_Config.csv", header = TRUE)
config <- as.character(R_Config$CONFIG_VALUE)

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
### Update with file to be processed
csv_in <- c(5:10)
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


# ### FETCH CACHED DATA FROM WAVE RDS FILES ####
#   datadir <- config[1]
#   ### Make a list of all the .rds files using full path
#   rds_files <- list.files(datadir,full.names = TRUE ,pattern = "\\.rds$")
#   rds_files # Take a look at list of files
#   ### Select which rds files needed for this script
#   rds_in <- c(3,4,7:9)
#   ### subset rds files (if you want all of them then skip rds_in and the following line)
#   rds_files <- rds_files[rds_in]
#   ### create an object that contains all of the rds files
#   data <- lapply(rds_files, readRDS)
#   ### Make a list of the df names by eliminating extension from files
#   df_names <- gsub(".rds", "", list.files(datadir, pattern = "\\.rds$"))
#   df_names <- df_names[rds_in]
#   # name each df in the data object appropriately
#   names(data) <- df_names
#   ### Extract each element of the data object into the global environment
#   list2env(data ,.GlobalEnv)
#   ### Remove data
#   rm(data)

### CONNECT TO A FRONT-END DATABASE ####
  
  ### Set DB
  #db <- config[3]
  ### Connect to Database 
  #con <- dbConnect(odbc::odbc(),
   #                .connection_string = paste("driver={Microsoft Access Driver (*.mdb)}",
    #                                          paste0("DBQ=", db), "Uid=Admin;Pwd=;", sep = ";"),
     #              timezone = "America/New_York")
  ### See the tables 
  #tables <- dbListTables(con)  
  ### Fetch an entire table (avoid using SQL queries - just pull entire tables and subset in R)
  #tbl <- dbReadTable(con, "tblParameters")
  ### Always disconnect and rm connection when done with db
  #dbDisconnect(con)
  #rm(con)

### SCRIPT BEGIN ####
for (i in data)
{select(i)}
  
  
df <- df %>% 
    select(4:7)
df$BioVolume[df$BioVolume < 0.001] <- 0

csv_name <- paste0(biobase_processed,"/", df_name,"_processed", ".csv")

write_csv(df, csv_name)


  
  
