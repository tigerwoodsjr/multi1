library(shiny)
library(tidyquant)
library(tidyverse)

mcap <- RTLedu::sp400_desc %>% 
  select(symbol, company, shares_held, sector, weight)
ticker <- unique(mcap$symbol)




