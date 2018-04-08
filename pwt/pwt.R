pklist <- c("tidyverse", "data.table", "readstata13")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

curl_download("http://www.rug.nl/ggdc/docs/pwt90.dta", "pwt90.dta", quiet = FALSE)

pwt.9.0 <- read.dta13("pwt90.dta")
unlink("pwt90.dta")
