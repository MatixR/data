pklist <- c("tidyverse", "data.table", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

year <- readline(prompt = "Enter a year between 2005 and 2015: ")

url.irs.soi <- "http://www.nber.org/tax-stats/zipcode/"
filename <- paste(year, "/zipcode", year, ".csv", sep = "")
filename.short <- paste("zipcode", year, sep = "")

cat("Downloading SOI Zipcode:", filename.short, "\n")
curl_download(paste(url.irs.soi, filename, sep = ""), filename.short, quiet = FALSE)
cat("Done!\n")
cat("Loading:", filename.short, "...")
assign(filename.short, read.csv(filename.short, header = TRUE, sep = ","))
cat(" Done!\n")
unlink(filename)
rm(url.irs.soi, year, filename, filename.short)
