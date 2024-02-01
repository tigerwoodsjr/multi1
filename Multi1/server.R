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
    ticker_data <- reactive({
      
    input_sector <- mcap %>% 
      dplyr::filter(symbol == input$tks) %>%
      pull(sector)
    
    toptwo <- mcap %>% 
      filter(sector == input_sector) %>%
      arrange(desc(weight)) %>% 
      head(2) %>% 
      pull(symbol)
    
    tq_pull <- append(input$tks, toptwo) %>% 
      unique()
    
    tidyquant::tq_get(tq_pull,
                           get = "stock.prices",
                           from = Sys.Date() - 365,
                           to = Sys.Date())
    }
    )
    
    output$distPlot <- renderPlotly({
    p1 <- plot_ly(data = ticker_data(),  x = ~date, y = ~adjusted, color = ~ symbol) %>%
      add_lines() %>%
      layout(title = paste0(input$tks, " vs. Top Two Holdings in ", mcap %>% filter(symbol == input$tks) %>% pull(sector)),
             xaxis = list(title = "Date"),
             yaxis = list(title = "Price"))
    p1
})
}


