library(shiny)
library(plotly)

rm(list=ls())

ui <- fluidPage(
  
  fluidRow(
    column(6,
           chartTableSwitchUI("firstUniqueID")
           )
    )
)

server <- function(input, output) {
  callModule(chartTableSwitch, "firstUniqueID")
}

shinyApp(ui = ui, server = server)