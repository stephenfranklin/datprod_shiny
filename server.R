
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); library(caret); library(ggplot2); library(rattle)

shinyServer(function(input, output) {
    
    ### Create Iris Training And Test Sets
    inTrain <- createDataPartition(y=iris$Species,
                                   p=0.7, list=FALSE)
    training <- iris[inTrain,]
    testing <- iris[-inTrain,]
    #    dim(training); dim(testing)
    
    ### faithful histogram ###
    output$distPlot <- renderPlot({
        
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        if(input$radio=="3")
            bins <- seq(min(x), max(x), length.out = input$bins + 1)
        else bins <- as.numeric(input$radio)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
        output$value <- renderPrint({ input$radio })
        
    })
    
    ### iris plot ###
    output$irisPlot1 <- renderPlot({
        qplot(Petal.Width,Sepal.Width,colour=Species,data=training)
    })
})
