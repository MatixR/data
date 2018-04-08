pklist <- c("tidyverse", "data.table", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

year <- readline(prompt = "Enter a year between 2011 and 2015: ")

url.irs.soi <- "https://www.irs.gov/pub/irs-soi/"
lookup.table <- data.table(year.number = 2011:2015, 
                           filenames = c("11incyallagi", 
                                         "12cyallagi", 
                                         "13incyallagi", 
                                         "14incyallagi", 
                                         "15incyallagi"))
filename <- lookup.table %>% 
  filter(year.number == year) %>% 
  select(filenames) %>% 
  unname %>% 
  unlist
cat("Downloading SOI county-level:", filename, "\n")
curl_download(paste(url.irs.soi, filename, ".csv", sep = ""), filename, quiet = FALSE)
cat("Done!\n")
cat("Loading:", filename, "...")
assign(filename, read.delim(filename, header = TRUE, sep = ","))
cat(" Done!\n")
unlink(filename)
rm(filename, url.irs.soi, year, lookup.table)
