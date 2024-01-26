#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library (plotly)






# Define server logic required to draw a histogram
function(input, output, session) {

    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     
    # 
    #     # draw the histogram with the specified number of bins
    #     #plot timeseries of stock w
    #     
    # 
    # })
    output$distPlot <- renderPlotly({

    # selected_pick <- tidyquant::tq_get(input$tks, 
    #                          get = "stock.prices", 
    #                          from = Sys.Date() - 365, 
    #                          to = Sys.Date())
    snp <- tidyquant::tq_get(ticker, 
                             get = "stock.prices", 
                             from = Sys.Date() - 365, 
                             to = Sys.Date())
    
    
    mcap <- RTLedu::sp400_desc %>% 
      select(symbol, shares_held, sector)
    
    joined <- snp %>% 
      group_by(symbol) %>%
      arrange(desc(date)) %>%
      slice(1) %>% 
      left_join(mcap, by = "symbol") %>% 
      mutate(mk = shares_held * adjusted) %>%
      select(symbol, date, adjusted, mk, sector)
    
    input_sector <- joined %>% 
      dplyr::filter(symbol == input$tks) %>%
      pull(sector)
    
    toptwo <- joined %>% 
      filter(sector == input_sector) %>%
      arrange(desc(mk)) %>% 
      head(2) %>% 
      pull(symbol)
    
    
    p1 <- snp %>% 
      filter(symbol == input$tks) %>% 
      plot_ly( x = ~date, y = ~adjusted, name = "S&P 400") %>%
      add_lines() %>%
      add_lines(data = snp %>% filter(symbol == toptwo[1]), y = ~adjusted, name = toptwo[1]) %>%
      add_lines(data = snp %>% filter(symbol == toptwo[2]), y = ~adjusted, name = toptwo[2]) %>%
      layout(title = "",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Price"))
    p1
})
}


