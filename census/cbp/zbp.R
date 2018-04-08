pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

year <- readline(prompt = "Enter a year between 1990 and 2015: ")

year2digit <- substr(paste(year), 3, 4)
url.cbp <- paste("https://www2.census.gov/programs-surveys/cbp/datasets/", year, "/", sep = "")
filename <- paste("zbp", year2digit, "detail", sep = "") 
filename.zip <- paste(filename, ".zip", sep = "")
filename.txt <- paste(filename, ".txt", sep = "")

curl_download(paste(url.cbp, filename, ".zip", sep = ""), destfile = filename.zip, quiet = FALSE)
unzip(filename.zip)
  
assign(filename, read.delim(filename.txt, header = TRUE, sep = ","))
unlink(filename.txt)
unlink(filename.zip)

rm(url.cbp, filename, filename.zip, filename.txt, year, year2digit)
