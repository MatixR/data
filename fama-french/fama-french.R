pklist <- c("data.table", "tidyverse", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

frenchFTP <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/"
suffixZIP <- "_TXT.zip"

colnames1 <- c("date","Mkt-RF","SMB","HML","RF")
colnames2 <- c("date","Mkt-RF","SMB","HML","RMW","CMA","RF")
colnames3 <- c("date","Neg", "Lo30","Med40","Hi30",
               "Lo20","Qnt2","Qnt3","Qnt4","Hi20",
               "Lo10","Dec2","Dec3","Dec4","Dec5",
               "Dec6","Dec7","Dec8","Dec9","Hi10")
colnames4 <- c("date","Lo30","Med40","Hi30",
               "Lo20","Qnt2","Qnt3","Qnt4","Hi20",
               "Lo10","Dec2","Dec3","Dec4","Dec5",
               "Dec6","Dec7","Dec8","Dec9","Hi10")
colnames5 <- c("date","Lo20","Qnt2","Qnt3","Qnt4","Hi20",
               "Lo10","Dec2","Dec3","Dec4","Dec5",
               "Dec6","Dec7","Dec8","Dec9","Hi10")
colnames6 <- c("date","Neg","Zero",
               "Lo20","Qnt2","Qnt3","Qnt4","Hi20",
               "Lo10","Dec2","Dec3","Dec4","Dec5",
               "Dec6","Dec7","Dec8","Dec9","Hi10")
colnames7 <- c("date","Momentum Factor")
colnames8 <- c("date",
               "SmallMom1","SmallMom2","SmallMom3",
               "BigMom1","BigMom2","BigMom3")
colnames9 <- c("date","S1M1","S1M2","S1M3","S1M4","S1M5","S2M1","S2M2","S2M3","S2M4","S2M5",
               "S3M1","S3M2","S3M3","S3M4","S3M5","S4M1","S4M2","S4M3","S4M4","S4M5",
               "S5M1","S5M2","S5M3","S5M4","S5M5")
colnames10 <- c("date","Mom1","Mom2","Mom3","Mom4","Mom5","Mom6","Mom7","Mom8","Mom9","Mom10")

DownloadFF <- function(series, colnames = NULL){
  curl_download(paste(frenchFTP, series, suffixZIP, sep = ""), paste(series, suffixZIP, sep = ""), quiet = FALSE)
  unzip(paste(series, suffixZIP, sep = ""))
  dt <- fread(paste(series,".txt",sep = ""), header = TRUE)
  file.remove(paste(series,".txt",sep = ""))
  if (!is.null(colnames)){
    setnames(dt, colnames)
  } else{
    names(dt)[1] <- "date"
  }
  
  dt <- dt %>%
    as.data.table %>%
    mutate(year = date %/% 100,
           month = date %% 100,
           date = as.yearmon(paste(year, month, sep = "-"))) %>%
    dplyr::select(-year, -month) %>%
    as.data.table() %>%
    setkey(date)
  return(dt)
}

# FF 3 factors ----------------

FF3 <- DownloadFF("F-F_Research_Data_Factors")

# FF 5 factors ----------------

FF5 <- DownloadFF("F-F_Research_Data_5_Factors_2x3", colnames2)

# Portfolios formed on ME ----------------

FF_ME <- DownloadFF("Portfolios_Formed_on_ME", colnames3)

# Portfolios formed on BE-ME ----------------

FF_BEME <- DownloadFF("Portfolios_Formed_on_BE-ME", colnames3)

# Portfolios formed on INV ----------------

FF_INV <- DownloadFF("Portfolios_Formed_on_INV", colnames4)

# Portfolios formed on OP ----------------

FF_OP <- DownloadFF("Portfolios_Formed_on_OP", colnames4)

# Portfolios formed on AC (Accruals) ----------------

FF_AC <- DownloadFF("Portfolios_Formed_on_AC", colnames5)

# Portfolios formed on BETA ----------------

FF_BETA <- DownloadFF("Portfolios_Formed_on_BETA", colnames5)

# Portfolios formed on NI (Net Issuances) ----------------

FF_NI <- DownloadFF("Portfolios_Formed_on_NI", colnames6)

# Portfolios formed on VAR (Variance) ----------------

FF_VAR <- DownloadFF("Portfolios_Formed_on_VAR", colnames5)

# Portfolios formed on RESVAR (Residual Variance) ----------------

FF_RESVAR <- DownloadFF("Portfolios_Formed_on_RESVAR", colnames5)

# Momentum Factor (Mom) --------------

FF_MOMENTUM <- DownloadFF("F-F_Momentum_Factor", colnames7)

# FF_MOM6 (Mom) --------------

FF_MOM6 <- DownloadFF("6_Portfolios_ME_Prior_12_2", colnames8)

# Momentum Factor (Mom) --------------

FF_SIZEMOM25 <- DownloadFF("25_Portfolios_ME_Prior_12_2", colnames9)

# Momentum Factor (Mom) --------------

FF_MOM10 <- DownloadFF("10_Portfolios_Prior_12_2", colnames10)

rm(DownloadFF, suffixZIP, frenchFTP, countrycode.EO, countrylist.EO, colnames1, colnames2, colnames3,
   colnames4,  colnames5,  colnames6,  colnames7,  colnames8,  colnames9,  colnames10)
