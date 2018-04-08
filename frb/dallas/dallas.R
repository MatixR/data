pklist <- c("data.table", "tidyverse", "xlsx")
# https://www.dallasfed.org/-/media/Documents/institute/houseprice/hp1604.xlsx

source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url <- "https://www.dallasfed.org/~/media/documents/institute/houseprice/"
filename <- "hp1704.xlsx"
curl_download(paste(url, filename, sep = ""), filename, quiet = FALSE)
list.sheets <- c("First", "HPI", "RHPI", "PDI", "RPDI")

for (i in 2:5){
  assign(list.sheets[i], read.xlsx(filename, 2) %>%
           rename(Time = X1) %>%
           melt(id.vars = "Time") %>% 
           filter(!is.na(Time)) %>%
           mutate(yearqtr = as.numeric(substr(Time, 1, 4)) + (as.numeric(substr(Time, 7, 7)) - 1)/4,
                  countryname = paste(variable)) %>%
           select(countryname, yearqtr, value) %>%
           arrange(countryname, yearqtr) %>%
           mutate(VARIABLE = list.sheets[i]))
}

unlink(filename)

lookup <- data.table(countryname = c("UK", "S..Korea", "New.Zealand", "US", "S..Africa"),
                     countryname2 = c("United Kingdom", "Korea", "New Zealand", "United States", "South Africa"))

DallasFed <- rbind(HPI, PDI, RHPI, RPDI) %>%
  as.data.table %>%
  merge(lookup, by = "countryname", all = TRUE) %>%
  mutate(countryname = ifelse(!is.na(countryname2), countryname2, countryname)) %>% # replace according to lookup table
  select(VARIABLE, countryname, yearqtr, value) %>%
  arrange(VARIABLE, countryname, yearqtr)

rm(lookup, HPI, PDI, RHPI, RPDI, filename, i, list.sheets, url)