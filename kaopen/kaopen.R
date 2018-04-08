pklist <- c("tidyverse", "data.table", "readstata13")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

curl_download("http://web.pdx.edu/~ito/kaopen_2015.dta", destfile = "kaopen_2015.dta", quiet = FALSE)

kaopen_2015 <- read.dta13("kaopen_2015.dta")
