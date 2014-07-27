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
    
    output$fit.out   <- renderPrint({outs()$out.finalModel})
    #output$plot.out  <- renderPlot({outs()$out.plot})
    output$table.out <- renderTable({outs()$out.table})
    output$pred.out  <- renderPlot({outs()$out.pred})   
        
    
    ### iris plot ###
    #output$iris.tree.plot1 <- renderPlot({
    #    qplot(Petal.Width,Petal.Length,colour=Species,data=training)
    #})
    
    ### train CART classification tree ###
    #set.seed(42)
    #iris.tree <- train(Species ~ .,method="rpart",data=training)
    #output$iris.tree.finalModel <- renderPrint({
    #    iris.tree$finalModel
    #})
    
    ### tree diagram ###
    #output$iris.tree.plot2 <- renderPlot({
    #    fancyRpartPlot(iris.tree$finalModel)
    #})
    
    ### Predict Test Set (tree) ###
    #set.seed(42)
    #pred.tree<-predict(iris.tree,newdata=testing)
    #testing$predRight.tree <- pred.tree==testing$Species
    
        ### Prediction Table (tree) ###
    #output$iris.tree.table <- renderTable({
    #    table(pred.tree,testing$Species)
    #})
    
        ### Prediction Plot (tree) ###
    #output$iris.tree.plot3 <- renderPlot({
    #    qplot(Petal.Width,Petal.Length,colour=predRight.tree,
    #          data=testing,main="newdata Predictions")
    #})
    
    ### train Random Forest ###
    #set.seed(42)
    #iris.rf <- train(Species~ .,data=training,method="rf",prox=TRUE)
    #output$iris.rf.finalModel <- renderPrint({
    #    iris.rf$finalModel
    #})
    
    ### get class centers from Random Forest ###
    #irisP <- classCenter(training[,c(3,4)], training$Species, 
    #                     iris.rf$finalModel$prox)  ## table of class centers
    #irisP <- as.data.frame(irisP)
    #irisP$Species <- rownames(irisP) 
    
    ### plot class centers (rf) ###
    #p <- qplot(Petal.Width, Petal.Length, col=Species,data=training)
    #p <- p + geom_point(aes(x=Petal.Width,y=Petal.Length,col=Species),
    #               size=5,shape=4,data=irisP)
    #output$iris.rf.plot1 <- renderPlot({
    #    p
    #})
    
    ### Predict Test Set (rf) ###
    #set.seed(42)
    #pred.rf <- predict(iris.rf,testing) ## list of predictions of species (a factor w/ 3 levels)
    #testing$predRight.rf <- pred.rf==testing$Species
    
        ### Prediction Table (rf) ###
    #output$iris.rf.table <- renderTable({
    #    table(pred.rf,testing$Species)
    #})
    
        ### Prediction Plot (rf) ###
    #output$iris.rf.plot2 <- renderPlot({
    #    qplot(Petal.Width,Petal.Length,colour=predRight.rf,
    #          data=testing,main="newdata Predictions")
    #})
    
    ### Reactive radio input and Tabbed output ###
    #inputModel <- reactive({input$model})
    
#     if(inputModel=="tree"){
#         output$fit.out   <- renderPrint({iris.tree$finalModel})
#         output$plot.out  <- renderPlot({fancyRpartPlot(iris.tree$finalModel)})
#         output$table.out <- renderTable({table(pred.tree,testing$Species)})
#         output$pred.out  <- renderPlot({qplot(Petal.Width,Petal.Length,
#                             colour=predRight.tree,data=testing,
#                             main="newdata Predictions")})
#     }
#     else {
#         output$fit.out   <- renderPrint({iris.rf$finalModel})
#         output$plot.out  <- renderPlot({p})
#         output$table.out <- renderTable({table(pred.rf,testing$Species)})
#         output$pred.out  <- renderPlot({qplot(Petal.Width,Petal.Length,
#                                               colour=predRight.rf,data=testing,
#                                               main="newdata Predictions")})
#     }  
})