pklist <- c("tidyverse", "data.table", "dplyr")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url <- "https://www.bis.org/statistics/"
# List: https://www.bis.org/statistics/full_data_sets.htm

filename.zip <- c("full_bis_long_pp_csv.zip", 
                  "full_bis_selected_pp_csv.zip",
                  "full_webstats_credit_gap_dataflow_csv.zip",
                  "full_bis_total_credit_csv.zip",
                  "full_bis_eer_csv.zip")
filename.csv <- c("WEBSTATS_LONG_PP_DATAFLOW_csv_col.csv", 
                  "WEBSTATS_SELECTED_PP_DATAFLOW_csv_col.csv",
                  "WEBSTATS_CREDIT_GAP_DATAFLOW_csv_col.csv",
                  "WEBSTATS_TOTAL_CREDIT_DATAFLOW_csv_col.csv",
                  "BISWEB_EERDATAFLOW_csv_col.csv")

# long_pp -------------

curl_download(paste(url, filename.zip[1], sep = ""), filename.zip[1], quiet = FALSE)
unzip(filename.zip[1])
unlink(filename.zip[1])

long_pp <- read.csv(filename.csv[1]) %>%
  select(Reference.area, starts_with("X")) %>%
  melt(id.vars = c("Reference.area")) %>%
  filter(!is.na(value)) %>%
  mutate(countryname = paste(Reference.area),
         variable = paste(variable),
         yearqtr = as.numeric(substr(variable, 2, 5)) + (as.numeric(substr(variable, 8, 8))-1)/4) %>%
  select(countryname, yearqtr, value) %>%
  arrange(countryname, yearqtr)

unlink(filename.csv[1])

save(long_pp, file = "long_pp.RData")

# selected_pp -------------

curl_download(paste(url, filename.zip[2], sep = ""), filename.zip[2], quiet = FALSE)
unzip(filename.zip[2])
unlink(filename.zip[2])

selected_pp <- read.csv(filename.csv[2]) %>%
  filter(UNIT_MEASURE == 628) %>%
  select(Reference.area, measure = Value, starts_with("X")) %>%
  melt(id.vars = c("Reference.area", "measure")) %>%
  filter(!is.na(value)) %>%
  mutate(countryname = paste(Reference.area),
         variable = paste(variable),
         yearqtr = as.numeric(substr(variable, 2, 5)) + (as.numeric(substr(variable, 8, 8))-1)/4) %>%
  select(measure, countryname, yearqtr, value) %>%
  arrange(measure, countryname, yearqtr)

unlink(filename.csv[2])

save(selected_pp, file = "selected_pp.RData")

# credit_gap -------------

curl_download(paste(url, filename.zip[3], sep = ""), filename.zip[3], quiet = FALSE)
unzip(filename.zip[3])
unlink(filename.zip[3])

credit_gap <- read.csv(filename.csv[3]) %>%
  filter(CG_DTYPE == "A") %>%
  select(Reference.area = Borrowers..country, starts_with("X")) %>%
  melt(id.vars = c("Reference.area")) %>%
  filter(!is.na(value)) %>%
  mutate(countryname = paste(Reference.area),
         variable = paste(variable),
         yearqtr = as.numeric(substr(variable, 2, 5)) + (as.numeric(substr(variable, 8, 8))-1)/4) %>%
  select(countryname, yearqtr, value) %>%
  arrange(countryname, yearqtr)

unlink(filename.csv[3])

save(credit_gap, file = "credit_gap.RData")

# Total Credit -------------

curl_download(paste(url, filename.zip[4], sep = ""), filename.zip[4], quiet = FALSE)
unzip(filename.zip[4])
unlink(filename.zip[4])

total_credit <- read.csv(filename.csv[4]) %>%
  select(Reference.area = Borrowers..country, Time.Period, starts_with("X")) %>%
  mutate(Time.Period = substr(Time.Period, 6, 100000)) %>%
  melt(id.vars = c("Reference.area", "Time.Period")) %>%
  filter(!is.na(value)) %>%
  mutate(countryname = paste(Reference.area),
         variable = paste(variable),
         yearqtr = as.numeric(substr(variable, 2, 5)) + (as.numeric(substr(variable, 8, 8))-1)/4) %>%
  select(series = Time.Period, countryname, yearqtr, value) %>%
  arrange(series, countryname, yearqtr)
  
unlink(filename.csv[4])

save(total_credit, file = "total_credit.RData")

# Long_PP -------------

curl_download(paste(url, filename.zip[5], sep = ""), filename.zip[5], quiet = FALSE)
unzip(filename.zip[5])
unlink(filename.zip[5])

eer <- read.csv(filename.csv[5]) %>%
  select(Reference.area, Time.Period, starts_with("X")) %>%
  mutate(Time.Period = substr(Time.Period, 1, 5)) %>%
  melt(id.vars = c("Reference.area", "Time.Period")) %>%
  filter(!is.na(value)) %>%
  mutate(countryname = paste(Reference.area),
         variable = paste(variable),
         yearqtr = as.numeric(substr(variable, 2, 5)) + (as.numeric(substr(variable, 8, 8))-1)/4) %>%
  select(series = Time.Period, countryname, yearqtr, value) %>%
  arrange(series, countryname, yearqtr)

unlink(filename.csv[5])

save(eer, file = "eer.RData")

rm(url, filename.csv, filename.zip)
