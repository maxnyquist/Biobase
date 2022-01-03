################################### HEADER ###################################
#   TITLE: 
#   DESCRIPTION:
#   AUTHOR(S): 
#   DATE LAST UPDATED: 
#   R VERSION 3.X.X
##############################################################################.

### LOAD PACKAGES ####
pkg <- c("tidyverse", "magrittr", "lubridate", "DBI", "odbc")
sapply(pkg, library, character.only = TRUE)

### SET OPTIONS/ENV VARIABLES ####

### Eliminate Scientific Notation
options(scipen = 999)

### SOURCE DATA/FUNCTIONS/FILES ####

#R_Config <- read.csv("//env.govt.state.ma.us/enterprise/DCR-WestBoylston-WKGRP/WatershedJAH/EQStaff/WQDatabase/R-Shared/Code/R_Config.csv", header = TRUE)
#config <- as.character(R_Config$CONFIG_VALUE)

### FETCH CACHED DATA FROM WAVE RDS FILES ####
datadir <- config[1]
### Make a list of all the .rds files using full path
rds_files <- list.files(datadir,full.names = TRUE ,pattern = "\\.rds$")
rds_files # Take a look at list of files
### Select which rds files needed for this script
rds_in <- c(3,4,7:9)
### subset rds files (if you want all of them then skip rds_in and the following line)
rds_files <- rds_files[rds_in]
### create an object that contains all of the rds files
data <- lapply(rds_files, readRDS)
### Make a list of the df names by eliminating extension from files
df_names <- gsub(".rds", "", list.files(datadir, pattern = "\\.rds$"))
df_names <- df_names[rds_in]
# name each df in the data object appropriately
names(data) <- df_names
### Extract each element of the data object into the global environment
list2env(data ,.GlobalEnv)
### Remove data
rm(data)

### CONNECT TO A FRONT-END DATABASE ####

### Set DB
db <- config[3]
### Connect to Database 
con <- dbConnect(odbc::odbc(),
                 .connection_string = paste("driver={Microsoft Access Driver (*.mdb)}",
                                            paste0("DBQ=", db), "Uid=Admin;Pwd=;", sep = ";"),
                 timezone = "America/New_York")
### See the tables 
tables <- dbListTables(con)  
### Fetch an entire table (avoid using SQL queries - just pull entire tables and subset in R)
tbl <- dbReadTable(con, "tblParameters")
### Always disconnect and rm connection when done with db
dbDisconnect(con)
rm(con)

### SCRIPT BEGIN ####
devtools::install_git("https://gitlab.com/hrbrmstr/arabia")
library(arabia)


datadir <- paste("W:/WatershedJAH/EQStaff/Aquatic Biology/GIS/ciBiobase_sl2")
data <- list.dirs(datadir)
datafolder <- data[14]
sl2_files <- list.files(datafolder, full.names = TRUE)
sl2_in <- c(1:40)
sl2_files <- sl2_files[sl2_in]
data_sl2 <- lapply(sl2_files, read_sl2)




devtools::install_git("https://gitlab.com/hrbrmstr/arabia")
library(arabia)
