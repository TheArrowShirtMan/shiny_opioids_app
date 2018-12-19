#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("State Opioid Dashboard", windowTitle = "David's Opioid Dashboard"),
  
  # Sidebar with a select input to choose state 
  sidebarLayout(
    sidebarPanel(width = 2,
      selectInput(inputId = "selectedstate", 
                  label = h3("Select State"), 
                  choices = prescribers_op_final$State,
                  selected = "AK")
                ),
    # Show plots and data table of the generated distribution
     mainPanel(
         column(8,
              plotOutput("providerPlot")),
         column(3,
                plotOutput("opioidsPlot")),
        dataTableOutput("providerTable")
     )
  )
))
