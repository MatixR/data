Household Credit: County Maps
================

``` r
pklist <- c("tidyverse", "data.table", "maps", "curl")
source("https://raw.githubusercontent.com/fgeerolf/R/master/load-packages.R")
source("https://raw.githubusercontent.com/fgeerolf/datasets/master/frb-ny/household.credit.R")
source("https://raw.githubusercontent.com/fgeerolf/R/master/map.countyfips.R")

household.credit.2006 <- household.credit %>%
  filter(year == 2006) %>%
  dcast(fips ~ variable, value.vars = "value")

map.countyfips(household.credit.2006 %>% select(fips, value = mortgage))
```

![](household.credit.map_files/figure-markdown_github/mortgage-1.png)

``` r
map.countyfips(household.credit.2006 %>% select(fips, value = auto))
```

![](household.credit.map_files/figure-markdown_github/auto-1.png)

``` r
map.countyfips(household.credit.2006 %>% select(fips, value = creditcard))
```

![](household.credit.map_files/figure-markdown_github/creditcard-1.png)
