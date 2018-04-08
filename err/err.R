pklist <- c("tidyverse", "data.table", "curl", "openxlsx", "stringi")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

# Ilzetzki, Ethan, Carmen M. Reinhart and Kenneth S. Rogoff (2017) 
# "Exchange Rate Arrangements Entering the 21st Century: Which Anchor Will Hold?"

url <- "http://www.carmenreinhart.com/user_uploads/data/"

files <- rbind(c("238_data.xlsx", 
                 "Exchange rate regime classification, annual, 1946-2016", 
                 "238_data.xlsx"),
               c("239_data.zip", 
                 "Exchange rate regime classification, monthly, 1946:1 - 2016:12", 
                 "Classification_Monthly_1940-2016.xlsx"))
              
for (i in 1:2){
  cat("\nCurrently downloading: ", files[i, 2])
  curl_download(paste(url, files[i, 1], sep = ""), files[i, 1], quiet = TRUE)
}

# Correspondance Coutries ----------

countrylist.imf <- read.csv("https://raw.githubusercontent.com/fgeerolf/data/master/crosswalks/correspondance-countries.csv", stringsAsFactors = FALSE, encoding = "Western") %>%
  mutate_all(funs(as.character(paste(.)))) %>%
  select(countryname.imf) %>%
  unlist %>%
  unname

countrylist.imf[44] <- "Côte d'Ivoire"

# COARSE CLASSIFICATION --------
# Annual.Coarse ----------

Annual.Coarse <- read.xlsx(files[1, 1], sheet = 4, startRow = 6)
names(Annual.Coarse)[-1] <- countrylist.imf
Annual.Coarse <- Annual.Coarse %>%
  rename(year = X1) %>%
  mutate(year = as.numeric(year)) %>%
  melt(id.vars = "year") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(year, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

# Monthly.Coarse --------

unzip("239_data.zip")

Monthly.Coarse <- read.xlsx(files[2, 3], sheet = 4, startRow = 6)
names(Monthly.Coarse)[-1] <- countrylist.imf
Monthly.Coarse <- Monthly.Coarse %>%
  rename(yearmonth = X1) %>%
  melt(id.vars = "yearmonth") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         yearmonth = as.character(yearmonth),
         yearmonth = as.numeric(substr(yearmonth, 1, 4)) + (as.numeric(substr(yearmonth, 6, 7))-1)/12,
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(yearmonth, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

# Quarterly.Coarse --------

Quarterly.Coarse <- Monthly.Coarse %>%
  filter(floor(4*yearmonth) == 4*yearmonth) %>%
  rename(yearqtr = yearmonth)

# FINE CLASSIFICATION --------
# Annual.Fine ----------

Annual.Fine <- read.xlsx(files[1, 1], sheet = 3, startRow = 6)
names(Annual.Fine)[-1] <- countrylist.imf
Annual.Fine <- Annual.Fine %>%
  rename(year = X1) %>%
  mutate(year = as.numeric(year)) %>%
  melt(id.vars = "year") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(year, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

# Monthly.Fine --------

Monthly.Fine <- read.xlsx(files[2, 3], sheet = 3, startRow = 6)
names(Monthly.Fine)[-1] <- countrylist.imf
Monthly.Fine <- Monthly.Fine %>%
  rename(yearmonth = X1) %>%
  melt(id.vars = "yearmonth") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         yearmonth = as.character(yearmonth),
         yearmonth = as.numeric(substr(yearmonth, 1, 4)) + (as.numeric(substr(yearmonth, 6, 7))-1)/12,
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(yearmonth, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

# Quarterly.Fine --------

Quarterly.Fine <- Monthly.Fine %>%
  filter(floor(4*yearmonth) == 4*yearmonth) %>%
  rename(yearqtr = yearmonth)

# DELETE FILES ---------

unlink(c(files[,c(1,3)]))
rm(countrylist.imf, files, url, i)
