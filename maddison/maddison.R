
pklist <- c("tidyverse", "data.table", "readstata13")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

curl_download("https://www.rug.nl/ggdc/historicaldevelopment/maddison/data/mpd2018.dta", "mpd2018.dta", quiet = FALSE)

maddison <- read.dta13("mpd2018.dta")
unlink("mpd2018.dta")
