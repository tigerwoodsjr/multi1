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
  
    output$distPlot <- renderPlotly({
      
    input_sector <- mcap %>% 
      dplyr::filter(symbol == input$tks) %>%
      pull(sector)
    
    toptwo <- mcap %>% 
      filter(sector == input_sector) %>%
      arrange(desc(weight)) %>% 
      head(2) %>% 
      pull(symbol)
    
    selected_pick <- tidyquant::tq_get(c(input$tks, toptwo),
                             get = "stock.prices",
                             from = Sys.Date() - 365,
                             to = Sys.Date())
    
    p1 <- plot_ly(data = selected_pick %>% filter(symbol == input$tks), x = ~date, y = ~adjusted, name = input$tks) %>%
      add_lines() %>%
      add_lines(data = selected_pick %>% filter(symbol == toptwo[1]), y = ~adjusted, name = toptwo[1]) %>%
      add_lines(data = selected_pick %>% filter(symbol == toptwo[2]), y = ~adjusted, name = toptwo[2]) %>%
      layout(title = paste0(input$tks, " vs. Top Two Holdings in ", input_sector),
             xaxis = list(title = "Date"),
             yaxis = list(title = "Price"))
    p1
})
}


