rm(list = ls())
pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

# State and Metro Area Employment, Hours, & Earnings -----------
# Source: https://download.bls.gov/pub/time.series/sm/

url <- "https://download.bls.gov/pub/time.series/la/"

curl_download(paste(url, "la.txt", sep = ""), "la.txt", quiet = FALSE)

list.file <- c("la.area", 
               "la.area_type", 
               "la.series",
               "la.period",
               "la.measure",
               "la.data.1.CurrentS",
               "la.data.2.AllStatesU",
               "la.data.3.AllStatesS",
               "la.data.4.RegionDivisionU",
               "la.data.5.RegionDivisionS")

for (file in list.file){
  cat("\nDownloading from BLS LAU (Local Area Unemployment) Website:", file)
  assign(file, read.delim(paste(url, file, sep = ""), row.names = NULL))
}

# Merge la.data.0_CurrentU datasets ------

list.file2 <- c("la.data.0.CurrentU00-04",
                "la.data.0.CurrentU05-09",
                "la.data.0.CurrentU10-14",
                "la.data.0.CurrentU15-19",
                "la.data.0.CurrentU90-94",
                "la.data.0.CurrentU95-99")


for (file in list.file2){
  cat("\nDownloading from BLS LAU (Local Area Unemployment) Website:", file)
  assign(file, read.delim(paste(url, file, sep = ""), row.names = NULL))
}

la.data.0 <- NA
for (dataset in ls()[grep("la.data.0.CurrentU", ls())]) la.data.0 <- rbind(la.data.0, get(dataset))