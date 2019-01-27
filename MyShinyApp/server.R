library(shiny)
library(tidyverse)
shinyServer(function(input, output) {
#  selectedMonth<-reactive({
#                airquality[airquality$Month==input$month,] })
  selectedMonth <- reactive({
    req(input$month) # ensure availablity of value before proceeding
    filter(airquality, Month %in% input$month)
  })
  model1<-reactive({
 #   WindSp <- ifelse(selectedMonth()$Wind - 10 > 0, selectedMonth()$Wind-10, 0)
  lm(Ozone ~ Wind, data = selectedMonth())
  })
  
 # model2<-reactive({
 #   WindSp <- ifelse(selectedMonth()$Wind - 10 > 0, selectedMonth()$Wind-10, 0)
 #   lm(Ozone ~ Wind+WindSp, data = selectedMonth())
 # })
  
  model1pred <- reactive({
    WindInput <- input$sliderWind
    predict(model1(), newdata = data.frame(Wind = WindInput))
  })
  # p1 <- reactive({
  #   newx <- data.frame(Wind = seq(0, 25, length = 100))
  #   predict(model1(), newdata= newx,interval = ("confidence"))})
  
#  p2 <-reactive({
 #   newx <- data.frame(Wind = seq(0, 25, length = 100))
 #   predict(model1(), newdata = newx,interval = ("prediction"))})
  
 # model2pred <- reactive({
 #   WindInput <- input$sliderWind
 #   predict(model2(), newdata = 
 #             data.frame(Wind = WindInput,
 #                        WindSp = ifelse(WindInput - 10 > 0, WindInput-10, 0)))
 # })
  output$Description <- renderText( 
    "This project builds a regression model on the relationship between Ozone and Wind Speed from the dataset {airquality}.
  The ShinyApp provides an interactive interface to allow users to select the month(s) of interest and build regression models on the selected month(s). The different models show the potentially different relationships between Ozone and Wind Speed at different months and invite further investigation into possible confounders such as temperature etc.
  The ShinyApp allows users to choose a wind speed and use the regression model to predict the ozone level.
  The users have options to show/hide the confidence intervals, the predicted point on the graph and also the subsetted data table."
  )
  
  output$plot1 <- renderPlot({
    WindInput <- input$sliderWind
    #  p1()$interval="confidence"
    # p2()$interval = "prediction"
  #  p1()$Wind = newx$Wind
  #  p2()$Wind = newx$Wind
  #   dat = cbind(p2(), newx)
#    names(dat())[1] = "Ozone"
 #    ggplot(p2(), aes(x = newx, y = fit))+
  #     geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.2) +
 #      geom_line()+
 #      geom_point(selectedMonth(), aes(x = Wind, y = Ozone))
    ggplot(selectedMonth(), aes(x=Wind, y=Ozone))+
       geom_point()+
       geom_smooth(method=lm,se=input$showConfInt)+
     geom_point(aes(x=WindInput, y=model1pred()), colour="red",alpha=as.numeric(input$showPred), size=4)
 #     
 #       ggplot(dat(), aes(x = newx, y = fit))+
 #    geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.2) +
 #    geom_line()+
 #    geom_point(selectedMonth(), aes(x = Wind, y = Ozone), size = 4)
 # #
 #  plot(selectedMonth()$Wind, selectedMonth()$Ozone, xlab = "Wind Speed Miles Per Hour",
 #       ylab = "Ozone Level", bty = "n", pch = 16,
 #        xlim = c(0, 25), ylim = c(0, 150))
   # if(input$showModel1){
  #    abline(model1(), col = "red", lwd = 2)
  #  }
  #  if(input$showModel2){
  #    model2lines <- predict(model2(), newdata = data.frame(
 #       Wind = 0:25, WindSp = ifelse(0:25 - 10 > 0, 0:25 - 10, 0)
  #    ))
  #    lines(0:25, model2lines, col = "blue", lwd = 2)
 #   }
#   legend("topright", "Model Prediction", pch = 16, 
 #          col = "blue", bty = "n", cex = 1.2)
  #  points(WindInput, model1pred(), col = "blue", pch = 16, cex = 2)
  #  points(WindInput, model2pred(), col = "blue", pch = 16, cex = 2)
  })
  
  output$pred1 <- renderText({
    model1pred()
  })
  
 # output$pred2 <- renderText({
 #   model2pred()
#  })
  output$table <- renderDataTable({if(input$showData){selectedMonth()}})
})