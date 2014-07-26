
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
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
                        value = 30)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            verticalLayout(
                plotOutput("distPlot"),
                plotOutput("iris.tree.plot1"),
                sidebarPanel(width = 12,
                             HTML(fragment.only=TRUE, text=c(
                                 "This is an absolutePanel that uses `bottom` and `right` attributes.

                    It also has `draggable = TRUE`, so you can drag it to move it around the page.
                    
                    The slight transparency is due to `style = 'opacity: 0.92'`.
                    
                    You can put anything in absolutePanel, including inputs and outputs:"
                             ))),
                verbatimTextOutput("iris.tree.finalModel"),
                plotOutput("iris.tree.plot2"),
                tableOutput("iris.tree.table"),
                plotOutput("iris.tree.plot3"),
                verbatimTextOutput("iris.rf.summary")
            )
        )
    )))


