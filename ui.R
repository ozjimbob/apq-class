
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jpeg)
library(sp)
library(maptools)
library(leaflet)

shinyUI(fluidPage(theme = "bootstrap.css",

  # Application title
  titlePanel("Aerial Photo Class"),

  # Sidebar with a slider input for number of bins
  fluidRow(
  column(width=4,
         selectInput("vegType","Majority Photo Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                    "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                    "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                    "Sandstone Heath"="Sandstone Heath",
                                                                    "Sandstone Woodland"="Sandstone Woodland",
                                                                    "Mangrove/Mud"="Mangrove/Mud",
                                                                    "Water/Bare","Water/Bare"),
                     multiple=FALSE),
         fluidRow(
           column(width=6,
              h3("Box 1"),
              
              selectInput("vegType1","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                   "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                   "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                   "Sandstone Heath"="Sandstone Heath",
                                                                   "Sandstone Woodland"="Sandstone Woodland",
                                                                   "Mangrove/Mud"="Mangrove/Mud",
                                                                   "Water/Bare","Water/Bare"),
                          multiple=FALSE),
              textInput("cattle1","Cattle",value=0),
              textInput("donkey1","Donkeys",value=0),
              textInput("emu1","Emus",value=0),
              textInput("pig1","Pigs",value=0),
              textInput("kangaroo1","Kangaroo",value=0),
              checkboxGroupInput("trackPresent1","Animal Track Present",
                         choices=c("Track"="Track",
                                   "Scald"="Scald",
                                   "Scrape"="Scrape")),
              textInput("note1","Notes",value=""),
              
              
              h3("Box 2"),
              selectInput("vegType2","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                   "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                   "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                   "Sandstone Heath"="Sandstone Heath",
                                                                   "Sandstone Woodland"="Sandstone Woodland",
                                                                   "Mangrove/Mud"="Mangrove/Mud",
                                                                   "Water/Bare","Water/Bare"),
                          multiple=FALSE),
              textInput("cattle2","Cattle",value=0),
              textInput("donkey2","Donkeys",value=0),
              textInput("emu2","Emus",value=0),
              textInput("pig2","Pigs",value=0),
              textInput("kangaroo2","Kangaroo",value=0),
              checkboxGroupInput("trackPresent2","Animal Track Present",
                                 choices=c("Track"="Track",
                                           "Scald"="Scald",
                                           "Scrape"="Scrape")),
              textInput("note2","Notes",value="")
              ),
         column(width=6,
              h3("Box 3"),
              selectInput("vegType3","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                   "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                   "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                   "Sandstone Heath"="Sandstone Heath",
                                                                   "Sandstone Woodland"="Sandstone Woodland",
                                                                   "Mangrove/Mud"="Mangrove/Mud",
                                                                   "Water/Bare","Water/Bare"),
                          multiple=FALSE),
              textInput("cattle3","Cattle",value=0),
              textInput("donkey3","Donkeys",value=0),
              textInput("emu3","Emus",value=0),
              textInput("pig3","Pigs",value=0),
              textInput("kangaroo3","Kangaroo",value=0),
              checkboxGroupInput("trackPresent3","Animal Track Present",
                                 choices=c("Track"="Track",
                                           "Scald"="Scald",
                                           "Scrape"="Scrape")),
              textInput("note3","Notes",value=""),
              h3("Box 4"),
              selectInput("vegType4","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                   "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                   "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                   "Sandstone Heath"="Sandstone Heath",
                                                                   "Sandstone Woodland"="Sandstone Woodland",
                                                                   "Mangrove/Mud"="Mangrove/Mud",
                                                                   "Water/Bare","Water/Bare"),
                          multiple=FALSE),
              textInput("cattle4","Cattle",value=0),
              textInput("donkey4","Donkeys",value=0),
              textInput("emu4","Emus",value=0),
              textInput("pig4","Pigs",value=0),
              textInput("kangaroo4","Kangaroo",value=0),
              checkboxGroupInput("trackPresent4","Animal Track Present",
                                 choices=c("Track"="Track",
                                           "Scald"="Scald",
                                           "Scrape"="Scrape")),
              textInput("note4","Notes",value="")
              )),
          actionButton("refresh","Submit"),
          leafletOutput("mymap")
              
    ),
  column(width=8,
    # Show a plot of the generated distribution
    mainPanel(
      imageOutput("preImage",height="800px",width="1200px")
    )
  )
)))
