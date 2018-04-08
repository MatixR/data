pklist <- c("tidyverse", "data.table", "curl", "openxlsx")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

RRfolder <- "/Users/geerolf/Drive/work/datasets/macro-misc/reinhart-rogoff/data"
setwd(RRfolder)

# Ilzetzki, Ethan, Carmen M. Reinhart and Kenneth S. Rogoff (2017) 
# "Exchange Rate Arrangements Entering the 21st Century: Which Anchor Will Hold?"

online <- TRUE

# If online download everything ----------
prefix <- "http://www.carmenreinhart.com/user_uploads/data/"
suffix.xlsx <- "_data.xlsx"
suffix.zip <- "_data.zip"

files <- t(rbind(paste(c("236", "237", "238", "239", "240", "241"), 
                       rep(c("_data.xlsx", "_data.zip"), 3), sep = ""),
               c("Anchor currency, annual, 1946-2016", 
                 "Anchor currency, monthly, 1946:1 - 2016:12", 
                 "Exchange rate regime classification, annual, 1946-2016",
                 "Exchange rate regime classification, monthly, 1946:1 - 2016:12", 
                 "Unified market analysis (capital control index), annual, 1946-2016", 
                 "Unified market analysis (capital control index), monthly, 1946-2016")))
for (i in 1:6){
  cat("\nCurrently downloading: ", files[i,2])
  curl_download(paste(prefix, files[i,1], sep = ""), files[i,1], quiet = TRUE)
}

# Correspondance Coutries ----------

countrylist.imf <- read.csv("https://raw.githubusercontent.com/fgeerolf/data/master/crosswalks/correspondance-countries.csv", stringsAsFactors = FALSE, encoding = "Western") %>%
  mutate_all(funs(as.character(paste(.)))) %>%
  select(countryname.imf) %>%
  unlist %>%
  unname

countrylist.imf[44] <- "Côte d'Ivoire"

# New ones ---------

data <- read.xlsx("236_data.xlsx", sheet = 2, startRow = 7)
?read.xlsx

unzip("237_data.zip")
unzip("239_data.zip")
unzip("241_data.zip")

# Annual.Fine.2016 ----------

Annual.Fine.2016 <- read.xlsx("238_data.xlsx", sheet = 3, startRow = 6)
names(Annual.Fine.2016)[-1] <- countrylist.imf

Annual.Fine.2016 <- Annual.Fine.2016 %>%
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

# Annual.Coarse.2016 ----------

Annual.Coarse.2016 <- read.xlsx("238_data.xlsx", sheet = 4, startRow = 6)
names(Annual.Coarse.2016)[-1] <- countrylist.imf

Annual.Coarse.2016 <- Annual.Coarse.2016 %>%
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

# Annual.Coarse.2016 --------

Annual.Coarse.2016 <- read.csv('238_data-Coarse.csv', stringsAsFactors = FALSE, encoding = "Western", skip = 5) %>%
  select(-X) %>%
  rename(year = X.1) %>%
  filter(!is.na(X.Afghanistan)) %>%
  mutate(year = as.numeric(paste(year)))

names(Annual.Coarse.2016)[-1] <- countrylist.imf

Annual.Coarse.2016 <- Annual.Coarse.2016 %>%
  melt(id.vars = "year") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(year, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

save(Annual.Coarse.2016, file = "../Annual.Coarse.2016.RData")

# Monthly.Coarse.2016 --------

Monthly.Coarse.2016 <- read.csv('Classification_Monthly_1940-2016-Coarse.csv', skip = 5) %>%
  select(-X) %>%
  rename(yearmonth = X.1) %>%
  filter(!is.na(X.Afghanistan)) 

names(Monthly.Coarse.2016)[-1] <- countrylist.imf

Monthly.Coarse.2016 <- Monthly.Coarse.2016 %>%
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

save(Monthly.Coarse.2016, file = "../Monthly.Coarse.2016.RData")

# Quarterly.Coarse.2016 --------

Quarterly.Coarse.2016 <- Monthly.Coarse.2016 %>%
  filter(floor(4*yearmonth) == 4*yearmonth) %>%
  rename(yearqtr = yearmonth)

save(Quarterly.Coarse.2016, file = "../Quarterly.Coarse.2016.RData")

# Annual.Fine.2016 --------

Annual.Fine.2016 <- read.csv('238_data-Fine.csv', skip = 5) %>%
  select(-X) %>%
  rename(year = X.1) %>%
  filter(!is.na(X.Afghanistan)) 

names(Annual.Fine.2016)[-1] <- countrylist.imf

Annual.Fine.2016 <- Annual.Fine.2016 %>%
  mutate(year = as.numeric(paste(year))) %>%
  melt(id.vars = "year") %>%
  mutate(value = ifelse(value == "MISSING", NA, value)) %>%
  mutate(value = as.numeric(value),
         variable = as.character(variable),
         variable = gsub('\\.'," ",variable),
         variable = stri_trans_totitle(paste(substring(variable,first=1,last=1),
                                             tolower(substring(variable,first=2,last=100000L)),sep=""))) %>%
  select(year, countryname = variable, ERregime = value) %>%
  filter(!is.na(ERregime))

save(Annual.Fine.2016, file = "../Annual.Fine.2016.RData")

# Monthly.Fine.2016 --------

Monthly.Fine.2016 <- read.csv('Classification_Monthly_1940-2016-Fine.csv', skip = 5) %>%
  select(-X) %>%
  rename(yearmonth = X.1) %>%
  filter(!is.na(X.Afghanistan)) 

names(Monthly.Fine.2016)[-1] <- countrylist.imf

Monthly.Fine.2016 <- Monthly.Fine.2016 %>%
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

save(Monthly.Fine.2016, file = "../Monthly.Fine.2016.RData")

# Quarterly.Fine.2016 --------

Quarterly.Fine.2016 <- Monthly.Fine.2016 %>%
  filter(floor(4*yearmonth) == 4*yearmonth) %>%
  rename(yearqtr = yearmonth)

save(Quarterly.Fine.2016, file = "../Quarterly.Fine.2016.RData")

# FineClassification --------

FineClassification <- read.csv('238_data-Classification.csv', skip = 6, nrows = 16) %>%
  select(indicator = X., description = X) %>%
  filter(!is.na(indicator))

save(FineClassification, file = "../FineClassification.RData")

# CoarseClassification --------

CoarseClassification <- read.csv('238_data-Classification.csv', skip = 26) %>%
  select(indicator = X., description = X) %>%
  filter(!is.na(indicator))

save(CoarseClassification, file = "../CoarseClassification.RData")



