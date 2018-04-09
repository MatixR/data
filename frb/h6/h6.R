pklist <- c("rsdmx", "tidyverse", "data.table", "plotly", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

filename <- "FRB_H6.zip"

curl_download('https://www.federalreserve.gov/datadownload/Output.aspx?rel=H6&filetype=zip', filename, quiet = FALSE)
unzip(filename)

h6 <- readSDMX("H6_data.xml", isURL = FALSE) %>%
  as.data.table

unlink(filename)
unlink(c("H6_data.xml", "H6_H6.xsd", "H6_struct.xml", "frb_common.xsd"))
