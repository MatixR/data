pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.zillow <- "http://files.zillowstatic.com/research/public/City/"

filename.list <- c("City_MedianValuePerSqft_AllHomes", 
                   "City_ZriPerSqft_AllHomes", 
                   "City_PriceToRentRatio_AllHomes", 
                   "City_Zri_AllHomes",
                   "City_PriceToRentRatio_AllHomes", 
                   "City_Zri_SingleFamilyResidenceRental", 
                   "City_MedianRentalPrice_AllHomes",
                   "City_Zhvi_BottomTier", 
                   "City_Zhvi_TopTier",
                   "City_Zhvi_Summary_AllHomes",
                   "Sale_Counts_Seas_Adj_City")

for (filename in filename.list){
  cat("Currently downloading:", filename, "\n")
  curl_download(paste(url.zillow, filename, ".csv", sep = ""), paste(filename, ".csv", sep = ""), quiet = FALSE)
  assign(filename, read.csv(paste(filename, ".csv", sep = "")))
  unlink(paste(filename, ".csv", sep = ""))
}

rm(url.zillow, filename.list, filename)
