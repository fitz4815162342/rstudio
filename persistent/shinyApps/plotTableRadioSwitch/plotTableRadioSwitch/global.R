rm(list=ls())

#define a simple dataframe for module example
X <- c("a", "b", "c")
Y <- c(1,2,3)
df <- data.frame(X,Y)


#UI function for first module
chartTableSwitchUI <- function(id){
  ns <- NS(id)
  tagList(
    radioButtons(ns("rb1"), "View", choices = c("Chart", "Table"),
                 selected = "Chart", inline = TRUE),
    conditionalPanel(
      condition = paste0('input[\'', ns('rb1'), "\'] == \'Chart\'"),
      plotlyOutput(ns("chart"))),
    conditionalPanel(
      condition = paste0('input[\'', ns('rb1'), "\'] == \'Table\'"),
      tableOutput(ns("chartTable")))
  )
}

#Server logic for first module
chartTableSwitch <- function(input, output, session){
  output$chart <- renderPlotly(
    plot_ly(df, x = ~X, y = ~Y) 
  )
  
  output$chartTable <- renderTable(df)
}