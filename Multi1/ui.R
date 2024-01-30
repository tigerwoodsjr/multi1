library(shiny)
library(plotly)
library(bslib)

fluidPage(
  theme = bslib::bs_theme(bootswatch = "united"),
  
  # Application title
  titlePanel("S&P 400"),
  
  # Sidebar with a slider input
  sidebarLayout(
    sidebarPanel(
      selectInput("tks", "Select Tickers", choices = ticker, multiple = F, selected = ticker[1]),
      tags$hr(),
      p("Select a ticker.")),
    
    # PLOT
    mainPanel(
      # div(
      #   style = "position: absolute; bottom: -475px; left: 50%; transform: translateX(-50%);",
        plotlyOutput("distPlot")
      )
    )
  )


