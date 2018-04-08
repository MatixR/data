pklist <- c("rsdmx", "tidyverse", "data.table", "plotly", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")

filename <- "FRB_H3.zip"

curl_download('https://www.federalreserve.gov/datadownload/Output.aspx?rel=H3&filetype=zip', filename, quiet = FALSE)
unzip(filename)

h3 <- readSDMX("H3_data.xml", isURL = FALSE) %>%
  as.data.table %>%
  mutate(OBS_VALUE = as.numeric(OBS_VALUE))

unlink(filename)
unlink(c("H3_data.xml", "H3_H3.xsd", "H3_struct.xml", "frb_common.xsd", "H3_H3_DISCONTINUED.xsd"))
