pklist <- c("rsdmx", "tidyverse", "data.table", "plotly", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

filename <- "FRB_H8.zip"

curl_download('https://www.federalreserve.gov/datadownload/Output.aspx?rel=H8&filetype=zip', filename, quiet = FALSE)
unzip(filename)

h8 <- readSDMX("H8_data.xml", isURL = FALSE) %>%
  as.data.table

unlink(filename)
unlink(c("H8_data.xml", "H8_H8.xsd", "H8_struct.xml", "frb_common.xsd"))