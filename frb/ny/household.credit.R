pklist <- c("tidyverse", "data.table", "readxl", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.newyorkfed <- "https://www.newyorkfed.org/medialibrary/media/research/national_economy/householdcredit/"
ccp.filename <- "county_report_by_year.xlsx"

curl_download(paste(url.newyorkfed, ccp.filename, sep = ""), destfile = ccp.filename, quiet = FALSE)

list.sheets <- excel_sheets(ccp.filename)

for (sheet in list.sheets[1]){
  assign(sheet, read_excel(ccp.filename, sheet = sheet, skip = 4) %>%
           melt(id.vars = c("state", "county", "county_code")) %>%
           mutate(year = as.numeric(substr(paste(variable), 3, 6)) + 0.75) %>%
           select(county_name = county, county_code, year, value) %>%
           arrange(county_code, year))
}

for (sheet in list.sheets[2]){
  assign(sheet, read_excel(ccp.filename, sheet = sheet, skip = 4) %>%
           select(-X__1) %>%
           melt(id.vars = c("state", "county_name", "county_code")) %>%
           mutate(year = as.numeric(substr(paste(variable), 3, 6)) + 0.75) %>%
           select(county_name, county_code, year, value) %>%
           arrange(county_code, year))
}

for (sheet in list.sheets[c(-2, -1)]){
  assign(sheet, read_excel(ccp.filename, sheet = sheet, skip = 4) %>%
           melt(id.vars = c("state", "county_name", "county_code")) %>%
           mutate(year = as.numeric(substr(paste(variable), 3, 6)) + 0.75) %>%
           select(county_name, county_code, year, value) %>%
           arrange(county_code, year))
}

household.credit <- auto %>% 
  rename(auto = value) %>%
  full_join(auto_delinq %>% rename(auto_delinq = value), by = c("county_name", "county_code", "year")) %>%
  full_join(creditcard %>% rename(creditcard = value), by = c("county_name", "county_code", "year")) %>%
  full_join(creditcard_delinq %>% rename(creditcard_delinq = value), by = c("county_name", "county_code", "year")) %>%
  full_join(mortgage %>% rename(mortgage = value), by = c("county_name", "county_code", "year")) %>%
  full_join(mortgage_delinq %>% rename(mortgage_delinq = value), by = c("county_name", "county_code", "year")) %>%
  full_join(population %>% rename(population = value), by = c("county_name", "county_code", "year")) %>%
  select(-county_name) %>%
  mutate(year = round(year)) %>%
  rename(fips = county_code) %>%
  melt(id.vars = 1:2) %>%
  filter(!is.na(value))

unlink(ccp.filename)
rm(auto, auto_delinq, creditcard, creditcard_delinq, mortgage, mortgage_delinq, 
   population, sheet, list.sheets, ccp.filename, url.newyorkfed)
