rm(list=ls()); ipak <- function(pkg){new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]; if (length(new.pkg)) install.packages(new.pkg, dependencies = TRUE); sapply(pkg, require, character.only = TRUE)}
pklist <- c("foreign","readstata13","stats4","plotrix","VGAM","fitdistrplus","ggplot2","GB2","xlsx",
            "data.table","dplyr","ggplot2","zoo","xts","dygraphs","gplots","foreign","car","plm","tseries","stats","dplyr","plyr",
            "stringr","pracma","expm","vars","tictoc","foreign","dplyr","tidyverse","tidyr","broom","mFilter","stats","DataCombine");  ipak(pklist); rm(pklist,ipak)

setwd("/Users/geerolf/Drive/work/datasets/bis/data/")

# Long_PP -------------

unzip('full_bis_long_pp_csv.zip')
long_pp <- read.csv("full_WEBSTATS_LONG_PP_DATAFLOW_csv.csv", skip = 6) 
file.remove("full_WEBSTATS_LONG_PP_DATAFLOW_csv.csv") 
long_pp <- melt(long_pp,id=names(long_pp)[1:3])

long_pp <- long_pp %>% filter(!is.na(value)) %>% 
  mutate(countryname=substr(Reference.area, start = 4, stop = 100000), 
         countrycode=substr(Reference.area, start = 1, stop = 2),
         yearqtr=paste(substr(variable,2,5)," Q",substr(variable,8,8),sep="")) %>%
  select(countryname,countrycode,yearqtr,value) %>% 
  arrange(countryname,yearqtr)

# Selected PP -------------

unzip('full_bis_selected_pp_csv.zip')
selected_pp <- read.csv("full_WEBSTATS_SELECTED_PP_DATAFLOW_csv.csv", skip = 5)
file.remove("full_WEBSTATS_SELECTED_PP_DATAFLOW_csv.csv") 
selected_pp <- melt(selected_pp,id=names(selected_pp)[1:5])

selected_pp_nominal <- selected_pp %>% filter(!is.na(value) & Value=="N:Nominal" & Unit.of.measure=="628:Index, 2010 = 100") %>% 
  mutate(countryname=substr(Reference.area, start = 4, stop = 100000), 
         countrycode=substr(Reference.area, start = 1, stop = 2),
         yearqtr=paste(substr(variable,2,5)," Q",substr(variable,8,8),sep="")) %>%
  select(countryname,countrycode,yearqtr,value) %>% 
  arrange(countryname,yearqtr)

selected_pp_real <- selected_pp %>% filter(!is.na(value) & Value=="R:Real" & Unit.of.measure=="628:Index, 2010 = 100") %>% 
  mutate(countryname=substr(Reference.area, start = 4, stop = 100000), 
         countrycode=substr(Reference.area, start = 1, stop = 2),
         yearqtr=paste(substr(variable,2,5)," Q",substr(variable,8,8),sep="")) %>%
  select(countryname,countrycode,yearqtr,value) %>% 
  arrange(countryname,yearqtr)

# Credit Gap -------------

unzip('full_webstats_credit_gap_dataflow_csv.zip')
credit_gap <- read.csv("full_WEBSTATS_CREDIT_GAP_DATAFLOW_csv.csv", skip = 15)
file.remove("full_WEBSTATS_CREDIT_GAP_DATAFLOW_csv.csv") 
credit_gap <- melt(credit_gap,id=names(credit_gap)[1])

# Total Credit -------------

setwd('/Users/geerolf/Drive/work/datasets/bis/data/')
unzip('full_bis_total_credit_csv.zip')
total_credit <- read.csv("full_WEBSTATS_TOTAL_CREDIT_DATAFLOW_csv.csv", skip = 5)
file.remove("full_WEBSTATS_TOTAL_CREDIT_DATAFLOW_csv.csv") 
total_credit <- melt(total_credit,id=names(total_credit)[1:8])

total_credit <- total_credit %>% 
  filter(!is.na(value)) %>% 
  mutate(countryname=substr(Borrowers..country, start = 4, stop = 100000), 
         yearqtr=paste(substr(variable,2,5)," Q",substr(variable,8,8),sep=""),
         series=substr(Time.Period, 6, 100000)) %>%
  select(countryname,yearqtr,series,value) %>% 
  arrange(countryname,yearqtr)
  

# Long_PP -------------

unzip('full_bis_eer_csv.zip')
eer <- read.csv("full_BISWEB_EERDATAFLOW_csv.csv", skip = 4)
file.remove("full_BISWEB_EERDATAFLOW_csv.csv") 
eer <- melt(eer,id=names(eer)[1:5])

# Arrange Datasets -------------


credit_gap <- credit_gap %>% filter(!is.na(value))

eer <- eer %>% filter(!is.na(value)) %>% 
  mutate(yearmonth=paste(substr(variable,2,5)," M",substr(variable,7,8),sep="")) %>%
  select(Type,Basket,Reference.area,seriesname=Time.Period,yearmonth,value) %>% 
  arrange(Type,Basket,Reference.area,yearmonth)

rm(selected_pp)




