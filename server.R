
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); library(caret); library(rpart);
library(randomForest); library(ggplot2); library(rattle)

shinyServer(function(input, output) {
    
    ### Create Iris Training And Test Sets
    set.seed(42)
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
        qplot(Petal.Width,Petal.Length,colour=Species,data=training)
    })
    
    ### train CART classification tree ###
    set.seed(42)
    iris.tree <- train(Species ~ .,method="rpart",data=training)
    output$iris.tree.finalModel <- renderPrint({
        iris.tree$finalModel
    })
    
    ### tree diagram ###
    output$iris.tree.plot2 <- renderPlot({
        fancyRpartPlot(iris.tree$finalModel)
    })
    
    ### Predict Test Set (tree) ###
    set.seed(42)
    pred.tree<-predict(iris.tree,newdata=testing)
    testing$predRight.tree <- pred.tree==testing$Species
    
        ### Prediction Table (tree) ###
    output$iris.tree.table <- renderTable({
        table(pred.tree,testing$Species)
    })
    
        ### Prediction Plot (tree) ###
    output$iris.tree.plot3 <- renderPlot({
        qplot(Petal.Width,Petal.Length,colour=predRight.tree,
              data=testing,main="newdata Predictions")
    })
    
    ### train Random Forest ###
    set.seed(42)
    iris.rf <- train(Species~ .,data=training,method="rf",prox=TRUE)
    output$iris.rf.finalModel <- renderPrint({
        iris.rf$finalModel
    })
    
    ### get class centers from Random Forest ###
    irisP <- classCenter(training[,c(3,4)], training$Species, 
                         iris.rf$finalModel$prox)  ## table of class centers
    irisP <- as.data.frame(irisP)
    irisP$Species <- rownames(irisP) 
    
    ### plot class centers (rf) ###
    p <- qplot(Petal.Width, Petal.Length, col=Species,data=training)
    p <- p + geom_point(aes(x=Petal.Width,y=Petal.Length,col=Species),
                   size=5,shape=4,data=irisP)
    output$iris.rf.plot1 <- renderPlot({
        p
    })
    
    ### Predict Test Set (rf) ###
    set.seed(42)
    pred.rf <- predict(iris.rf,testing) ## list of predictions of species (a factor w/ 3 levels)
    testing$predRight.rf <- pred.rf==testing$Species
    
        ### Prediction Table (rf) ###
    output$iris.rf.table <- renderTable({
        table(pred.rf,testing$Species)
    })
    
        ### Prediction Plot (rf) ###
    output$iris.rf.plot2 <- renderPlot({
        qplot(Petal.Width,Petal.Length,colour=predRight.rf,
              data=testing,main="newdata Predictions")
    })
})