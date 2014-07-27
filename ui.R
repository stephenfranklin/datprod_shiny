
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Shiny Application"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            radioButtons("radio", label = h3("Radio buttons"),
                         choices = list("2" = 1, "10" = 10,
                                        "slider" = 3),selected = 10),
            fluidRow(verbatimTextOutput("value")),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            
            sliderInput("train_percent",
                        "Training Percentage:",
                        min = 0.10, max = 0.90, 
                        value = 0.20, step = 0.10),
            
            radioButtons("method", "Model method:",
                         c("CART" = "rpart",
                           "Random Forest" = "rf")
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            verticalLayout(
                plotOutput("distPlot"),
                #plotOutput("iris.tree.plot1"),
                tabsetPanel(type = "tabs", 
                    tabPanel("Fit", verbatimTextOutput("fit.out")), 
                    #tabPanel("Plot", plotOutput("plot.out")), 
                    tabPanel("Prediction Table", tableOutput("table.out")),
                    tabPanel("Prediction Plot", plotOutput("pred.out")),
                    tabPanel("Doc", includeMarkdown("doc.md"))
                )#,
                            
                #verbatimTextOutput("iris.tree.finalModel"),
                #plotOutput("iris.tree.plot2"),
                #tableOutput("iris.tree.table"),
                #plotOutput("iris.tree.plot3"),
                #verbatimTextOutput("iris.rf.finalModel"),
                #plotOutput("iris.rf.plot1"),
                #tableOutput("iris.rf.table"),
                #plotOutput("iris.rf.plot2")
            )
        )
    )
))

