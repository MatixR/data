pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.nber <- "http://www.nber.org/cbsa-msa-fips-ssa-county-crosswalk/"
filename <- "cbsatocountycrosswalk"

county.to.cbsa <- read.csv(paste(url.nber, filename, ".csv", sep = ""))
rm(filename, url.nber)
