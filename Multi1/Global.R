library(shiny)
library(tidyquant)
library(tidyverse)



tickers <- RTLedu::sp400_prices
ticker <- unique(tickers$symbol)




