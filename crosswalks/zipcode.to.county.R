pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

zipcode.to.county <- read.delim("https://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt", sep = ",") %>%
  mutate(fips = STATE*1000+COUNTY) %>%
  select(zipcode = ZCTA5, fips) %>%
  arrange(zipcode)
