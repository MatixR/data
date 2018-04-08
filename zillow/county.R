pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.zillow <- "http://files.zillowstatic.com/research/public/County/"

filename.list <- c("County_MedianValuePerSqft_AllHomes", 
                   "County_ZriPerSqft_AllHomes", 
                   "County_PriceToRentRatio_AllHomes", 
                   "County_Zri_AllHomes",
                   "County_PriceToRentRatio_AllHomes", 
                   "County_Zri_SingleFamilyResidenceRental", 
                   "County_MedianRentalPrice_AllHomes",
                   "County_Zhvi_BottomTier", 
                   "County_Zhvi_TopTier",
                   "County_Zhvi_Summary_AllHomes",
                   "Sale_Counts_Seas_Adj_County")

for (filename in filename.list){
  cat("Currently downloading:", filename, "\n")
  curl_download(paste(url.zillow, filename, ".csv", sep = ""), paste(filename, ".csv", sep = ""), quiet = FALSE)
  assign(filename, read.csv(paste(filename, ".csv", sep = "")))
  unlink(paste(filename, ".csv", sep = ""))
}

rm(url.zillow, filename.list, filename)
