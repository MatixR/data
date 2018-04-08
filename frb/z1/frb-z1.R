pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.frb.z1 <- "https://www.federalreserve.gov/releases/z1/20180308/"
filename.zip <- "z1_csv_files.zip"

curl_download(paste(url.frb.z1, filename.zip, sep = ""), filename.zip, quiet = FALSE)
unzip(filename.zip)
unlink(filename.zip)
rm(filename.zip)

list.files.csv <- list.files("csv")
list.files.txt <- list.files("data_dictionary")

frb.z1 <- NULL

for (i in 1:length(list.files.csv)){
  cat("\nCurrently adding file", i, "of", length(list.files.csv), ":", list.files.csv[i])
  temp.csv.names <-  read.csv(paste("csv/", list.files.csv[i], sep = "")) %>%
    dplyr::select(-date) %>%
    names() %>%
    as.data.table %>%
    rename(colname = ".") %>%
    mutate(nvar = 1:n())
  
  temp.txt.names <- read.delim(paste("data_dictionary/", list.files.txt[i], sep = ""), header = FALSE) %>%
    mutate(nvar = 1:n()) %>%
    merge(temp.csv.names, by = "nvar") %>%
    dplyr::select(-nvar) %>%
    rename(series = V1, sector = V2, line = V3, source = V4, unit = V5) %>%
    mutate(colname = as.factor(colname)) %>%
    dplyr::select(colname, series, everything())
  
  rm(temp.csv.names)
  
  temp.file <- read.csv(paste("csv/", list.files.csv[i], sep = "")) %>%
    melt(id.vars = "date") %>%
    mutate(date = as.factor(date)) %>%
    rename(colname = variable) %>%
    mutate(colname = as.character(colname)) %>%
    merge(temp.txt.names, by = "colname")
  
  rm(temp.txt.names)
  
  frb.z1 <- rbind(frb.z1, temp.file)
  
  rm(temp.file)
}

unlink("csv", recursive = TRUE)
unlink("data_dictionary", recursive = TRUE)
unlink("frb_common.xsd")

frb.z1.list <- frb.z1 %>%
  select(-date, -value) %>%
  unique

rm(folder.frb.z1, i, list.files.csv, list.files.txt, url.frb.z1)
