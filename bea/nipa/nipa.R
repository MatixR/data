pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")
url.bea <- "https://bea.gov/national/Release/TXT/"

filename <- "NipaDataQ.txt"
cat("Currently loading:", filename)

nipa <- read.delim(paste(url.bea, filename, sep = ""), sep = ",", colClasses = "character", 
                   col.names = c("seriescode", "period", "value"), dec = ",") %>%
  mutate(value = gsub(",", "", value),
         value = as.numeric(value))

filename <- "NipaDataA.txt"
cat("\nCurrently loading:", filename)

nipa.annual <- read.delim(paste(url.bea, filename, sep = ""), sep = ",", colClasses = "character", 
                          col.names = c("seriescode", "period", "value"), dec = ",") %>%
  mutate(value = gsub(",", "", value),
         value = as.numeric(value))


filename <- "SeriesRegister.txt"
cat("\nCurrently loading:", filename)

nipa.series <- read.delim(paste(url.bea, filename, sep = ""), sep = ",", colClasses = "character",  dec = ",", 
                          col.names = c("seriescode", "serieslabel", "metricname", "calculationtype", "defaultscale", "tableid", "seriescodeparents"))

rm(filename, url.bea)
