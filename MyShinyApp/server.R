library(shiny)
library(tidyverse)
shinyServer(function(input, output) {
  selectedMonth <- reactive({
    req(input$month) # ensure availablity of value before proceeding
    filter(airquality, Month %in% input$month)
  })
  model<-reactive({
  lm(Ozone ~ Wind, data = selectedMonth())
  })
  modelpred <- reactive({
    WindInput <- input$sliderWind
    predict(model(), newdata = data.frame(Wind = WindInput))
  })
  output$Description <- renderText( 
    "This project builds a regression model on the relationship between Ozone and Wind Speed from the dataset {airquality}.
  The ShinyApp provides an interactive interface to allow users to select the month(s) of interest and build regression models on the selected month(s). The different models show the potentially different relationships between Ozone and Wind Speed at different months and invite further investigation into possible confounders such as temperature etc.
  The ShinyApp allows users to choose a wind speed and use the regression model to predict the ozone level.
  The users have options to show/hide the confidence intervals, the predicted point on the graph and also the subsetted data table."
  )
  output$plot1 <- renderPlot({
    WindInput <- input$sliderWind
    ggplot(selectedMonth(), aes(x=Wind, y=Ozone))+
       geom_point()+
       geom_smooth(method=lm,se=input$showConfInt)+
     geom_point(aes(x=WindInput, y=modelpred()), colour="red",alpha=as.numeric(input$showPred), size=4)
  })
  output$pred1 <- renderText({
    modelpred()
  })
  output$table <- renderDataTable({if(input$showData){selectedMonth()}})
})