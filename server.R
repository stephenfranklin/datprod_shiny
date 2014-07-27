# server.R
# Stephen Franklin 
# Course Project for Developing Data Products - Coursera
# by Brian Caffo at Johns Hopkins - 27-07-14

# This interactive Shiny web application compares
# two different machine learning algorithms.
#
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

### Libraries ###
library(shiny); library(caret); library(rpart);
library(randomForest); library(ggplot2); library(rattle);
library(e1071); library(rpart.plot)

### Functions ###

## Create Iris Training And Test Sets with given train percentage
partitionData <- function(train_percent){
    data(iris)
    set.seed(42)
    inTrain <- createDataPartition(y=iris$Species, p=train_percent, list=FALSE)
    training <- iris[inTrain,]
    testing <- iris[-inTrain,]
    #dim(training); dim(testing)
    invisible( list(training=training, testing=testing) )
}

## plot class centers (rf)
    # get class centers from Random Forest
plot.iris.centers <- function(fit.rf, train_data){
    irisP <- classCenter(training[,c(3,4)], training$Species, 
            fit.rf$finalModel$prox)  ## table of class centers
    irisP <- as.data.frame(irisP)
    irisP$Species <- rownames(irisP) 

    p <- qplot(Petal.Width,Petal.Length,col=Species,data=train_data)
    p <- p + geom_point(aes(x=Petal.Width,y=Petal.Length,col=Species),
                    size=5,shape=4,data=irisP)
    invisible(p)
}

## Partition, Train, Output tables and plots
interact <- function(train_percent, method){
    data <- partitionData(train_percent) ## list of training, testing.
    ## Train Model Fit
    set.seed(42)
    fit <- train(Species ~ ., method=method, data=data$training)
    set.seed(42)
    pred <- predict(fit,newdata=data$testing)
    predRight <- pred==data$testing$Species
    
    ## Output
    out.finalModel <- fit$finalModel
    
    out.table <- table(pred,data$testing$Species)
    
    out.pred  <- qplot(Petal.Width,Petal.Length,
                    colour=predRight,data=data$testing,
                    main="newdata Predictions")
    #if(method=="rf") out.plot <- plot.iris.centers(fit,data$training)
    #else if(method=="rpart") out.plot <- fancyRpartPlot(fit$finalModel)
    #else out.plot <- NULL
    
    list(out.finalModel=out.finalModel,
                    out.table=out.table,
                    out.pred=out.pred #,
                    #out.plot=out.plot
         )
}

### Server Logic ###
shinyServer(function(input, output) {
    
    ### Reactive expression called whenever inputs change.
    outs <- reactive({interact(input$train_percent, input$method)})
    
    output$fit.out   <- renderPrint({outs()$out.finalModel})
    #output$plot.out  <- renderPlot({outs()$out.plot})
    output$table.out <- renderTable({outs()$out.table})
    output$pred.out  <- renderPlot({outs()$out.pred})     
})