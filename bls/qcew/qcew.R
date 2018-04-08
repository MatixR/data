pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.bls.cew <- "https://data.bls.gov/cew/data/files/"
year <- readline(prompt = "Enter a year between 1990 and 2017: ")

file.csv <- paste(year, ".q1-q4.singlefile.csv", sep = "")
file.zip <- paste(year, "_qtrly_singlefile.zip", sep = "")
data.name <- paste("qcew.", year, sep = "")

cat("Downloading QCEW from BLS...\n")
curl_download(url = paste(url.bls.cew, year, "/csv/", file.zip, sep = ""), destfile = file.zip, quiet = FALSE, mode = "wb")
cat("Done!\n")

cat("Unzip", file.zip, "... ")
unzip(file.zip)
unlink(file.zip)
cat("Done!\n")

cat("Load", file.csv, "... ")
assign(data.name, read.csv(file.csv))
unlink(file.csv)
cat("Done!\n")

rm(data.name, file.csv, file.zip, folder.qcew, url.bls.cew)
