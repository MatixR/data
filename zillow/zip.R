pklist <- c("tidyverse", "data.table")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

url.zillow <- "http://files.zillowstatic.com/research/public/Zip/"

filename.list <- c("Zip_MedianValuePerSqft_AllHomes", 
                   "Zip_ZriPerSqft_AllHomes", 
                   "Zip_PriceToRentRatio_AllHomes", 
                   "Zip_Zri_AllHomes",
                   "Zip_PriceToRentRatio_AllHomes", 
                   "Zip_Zri_SingleFamilyResidenceRental", 
                   "Zip_MedianRentalPrice_AllHomes",
                   "Zip_Zhvi_BottomTier", 
                   "Zip_Zhvi_TopTier",
                   "Zip_Zhvi_Summary_AllHomes")
               
for (filename in filename.list){
  cat("Currently downloading:", filename, "\n")
  curl_download(paste(url.zillow, filename, ".csv", sep = ""), paste(filename, ".csv", sep = ""), quiet = FALSE)
  assign(filename, read.csv(paste(filename, ".csv", sep = "")))
  unlink(paste(filename, ".csv", sep = ""))
}
