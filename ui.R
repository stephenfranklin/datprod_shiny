# ui.R
# Stephen Franklin 
# Course Project for Developing Data Products - Coursera
# by Brian Caffo at Johns Hopkins - 27-07-14

# This interactive Shiny web application compares
# two different machine learning algorithms.
#
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); library(markdown)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Comparing Machine Learning Algorithms"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("train_percent",
                        "Training Percentage:",
                        min = 0.10, max = 0.90, 
                        value = 0.20, step = 0.10),
            br(),
            radioButtons("method", "Model method:",
                         c("CART" = "rpart",
                           "Random Forest" = "rf")
            )
        ),

        mainPanel(
            verticalLayout(
                #plotOutput("distPlot"),
                #plotOutput("iris.tree.plot1"),
                tabsetPanel(type = "tabs", 
                    tabPanel("Fit", verbatimTextOutput("fit.out")), 
                    #tabPanel("Plot", plotOutput("plot.out")), 
                    tabPanel("Prediction Table", tableOutput("table.out")),
                    tabPanel("Prediction Plot", plotOutput("pred.out")),
                    tabPanel("Doc", includeMarkdown("doc.md"))
                )
            )
        )
    )
))

