pklist <- c("tidyverse", "data.table", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

cat("Downloading WDI_csv.zip from databank.worldbank.org...\n")
curl_download(url = "http://databank.worldbank.org/data/download/WDI_csv.zip", destfile = "WDI_csv.zip", quiet = FALSE, mode = "wb")
cat("Done!\n")

cat("Unzipping... ")
unzip("WDI_csv.zip")
cat("Done!\n")

cat("Reading files: WDIData.csv, WDISeries.csv... ")
WDI <- read.csv('WDIData.csv')
WDISeries <- read.csv('WDISeries.csv')
cat("Done!\n")

unlink("WDI_csv.zip")
for (file in list.files(include.dirs = FALSE, recursive = TRUE, pattern = "\\.csv$")) unlink(file)

# WDI -------------

WDI <- WDI %>%
  melt(id.vars = 1:4) %>%
  mutate(year = as.factor(as.numeric(substr(variable, 2, 5)))) %>%
  select(-variable) %>%
  filter(!is.na(value))

# Dataset with number of obs per variable -------------

WDI.variable.nobs <- WDI %>%
  group_by(Indicator.Name, Indicator.Code) %>%
  summarise(nobs = sum(!is.na(value))) %>%
  ungroup %>%
  select(Indicator.Code, Indicator.Name, nobs) %>%
  mutate(Indicator.Code = as.character(paste(Indicator.Code)),
         Indicator.Name = as.character(paste(Indicator.Name))) %>%
  arrange(Indicator.Code) %>%
  unique
