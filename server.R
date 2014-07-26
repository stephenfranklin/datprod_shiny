
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); library(caret); library(rpart);
library(randomForest); library(ggplot2); library(rattle)

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
    output$iris.tree.plot1 <- renderPlot({
        qplot(Petal.Width,Sepal.Width,colour=Species,data=training)
    })
    
    ### train CART classification tree ###
    iris.tree <- train(Species ~ .,method="rpart",data=training)
    output$iris.tree.finalModel <- renderPrint({
        (iris.tree$finalModel)
    })
    
    ### tree diagram ###
    output$iris.tree.plot2 <- renderPlot({
        fancyRpartPlot(iris.tree$finalModel)
    })
    
    ### Predict Test Set (tree) ###
    pred1<-predict(iris.tree,newdata=testing)
    testing$predRight <- pred1==testing$Species
    
        ### Prediction Table (tree) ###
    output$iris.tree.table <- renderTable({
        table(pred1,testing$Species)
    })
    
        ### Prediction Plot (tree) ###
    output$iris.tree.plot3 <- renderPlot({
        qplot(Petal.Width,Petal.Length,colour=predRight,
              data=testing,main="newdata Predictions")
    })
    
    ### train Random Forest ###
    iris.rf <- train(Species~ .,data=training,method="rf",prox=TRUE)
    output$iris.rf.summary <- renderPrint({
        iris.rf
    })

    
})