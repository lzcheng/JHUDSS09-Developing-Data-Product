library(shiny)
library(tidyverse)
shinyUI(fluidPage(
  titlePanel("Predict Ozone Level from Wind Speed - Shiny Project by Lei Cheng"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderWind", "What is the wind speed in miles per hour?", 0, 25, value = 10),
      checkboxInput("showConfInt", "Show/Hide Confidence Interval", value = TRUE),
     checkboxInput("showPred", "Show/Hide Predicted Point", value = TRUE),
      checkboxInput("showData", "Show/Hide Data", value = TRUE),
      checkboxGroupInput(inputId = "month",
                     label = "Select month(s) of interest:",
                     choices = levels(as.factor(airquality$Month)),
                     selected = 5),
       submitButton("Submit")
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Description", br(), textOutput("Description")), 
                  tabPanel("Main App", br(), 
                           plotOutput("plot1"),
                           h3("Predicted Ozone Level from the Regression Model:"),
                           textOutput("pred1"),
                           #    h3("Predicted Ozone Level from Model 2:"),
                           #     textOutput("pred2"),
                           hr(),
                           dataTableOutput('table'))
      )
    )
  )
))