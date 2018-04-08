pklist <- c("tidyverse", "data.table", "haven", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

curl_download(url = "https://publications.iadb.org/bitstream/handle/11319/7408/The-Database-of-Political-Institutions-2015-DPI2015.zip", "database.zip", quiet = FALSE)

unzip("database.zip")
unlink("database.zip")
DPI2015 <- read_dta("DPI2015/DPI2015.dta")
unlink("DPI2015", recursive = TRUE)