pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.basic <- "http://files.zillowstatic.com/research/public/"

filename <- "CountyCrossWalk_Zillow"
filename.csv <- paste(filename, ".csv", sep = "")

assign(filename, read.csv(paste(url.basic, filename.csv, sep = "")))
