
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Aerial Photo Class"),

  # Sidebar with a slider input for number of bins
  fluidRow(
  column(width=2,
      radioButtons("vegType","Majority Photo Veg Class",choices=c("Savanna"="Savanna",
                                                        "Swamp"="Swamp",
                                                        "Sandstone"="Sandstone",
                                                        "Water"="Water",
                                                        "Grass"="Grass")),
      checkboxGroupInput("trackPresent","Animal Track Present",
                         choices=c("Box 1"="b1",
                                   "Box 2"="b2",
                                   "Box 3"="b3",
                                   "Box 4"="b4",
                                   "Box 5"="b5",
                                   "Box 6"="b6")),
      leafletOutput("mymap"),
      
      
      
      actionButton("refresh",
                  "Submit")
    ),
  column(width=10,
    # Show a plot of the generated distribution
    mainPanel(
      imageOutput("preImage",height="800px",width="1200px")
    )
  )
)))
