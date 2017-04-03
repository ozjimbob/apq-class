
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jpeg)
library(sp)
library(maptools)
library(leaflet)
library(magick)

test=FALSE

if(test==TRUE){
  imglistdata = read.csv("data/photos_order.csv",stringsAsFactors=FALSE)
  imglistdata$X.1 = NULL
  imglistdata$Done=FALSE
}else{
  imglistdata = read.csv("data/photos_order.csv",stringsAsFactors=FALSE)
  imglistdata$X.1 = NULL
  if(! "Done" %in% names(imglistdata)){
    imglistdata$Done=FALSE
  }
}

shinyServer(function(input, output,session) {
  
  data <- reactiveValues(
    class_fr = imglistdata,
    thispt = NULL,
    upto=ifelse(nrow(subset(imglistdata,Done==TRUE))>0,max(subset(imglistdata,Done==TRUE)$order)+1,1),
    setup=TRUE
  )
  
  observe({data$setup
    if(data$setup==TRUE){
    data$upto=ifelse(nrow(subset(data$class_fr,Done==TRUE))>0,max(subset(data$class_fr,Done==TRUE)$order)+1,1)
    print(data$upto)
    # Put the data for the selected row in the in the data$thispt object
    data$thispt=data$class_fr[data$class_fr$order == data$upto,]
    data$setup=FALSE
    }
  })
  ### If user changes the generic veg class, update veg classes for all quadrats
  observeEvent(input$vegType,{
    overallVeg = input$vegType
    updateSelectInput(session,"vegType1","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"),
                      selected = overallVeg)
    updateSelectInput(session,"vegType2","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"),
                      selected = overallVeg)
    updateSelectInput(session,"vegType3","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"),
                      selected = overallVeg)
    updateSelectInput(session,"vegType4","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"),
                      selected = overallVeg)
  })
  
  # When the page is refreshed/submitted, write data, load next photo
  observeEvent( input$refresh,{
    
    if(!is.null(data$thispt)){
      # Grab the current point information and make a dataframe where it's repeated 4 times
      thisdt=data$thispt
      thisdt = thisdt[rep(seq_len(nrow(thisdt)), each=4),]
      # Add a sequence ID column
      thisdt$SqID = 1:4
      
      thisdt$drainage = rep(input$drainage,4)
      
      # Add a veg type column with the veg type information
      thisdt$vegType = c(input$vegType1,input$vegType2,input$vegType3,input$vegType4)
      
      # Add a cattle type column with the cattle counts
      thisdt$cattle = c(input$cattle1,input$cattle2,input$cattle3,input$cattle4)
      # Add a cattle type column with the cattle counts
      thisdt$donkey = c(input$donkey1,input$donkey2,input$donkey3,input$donkey4)
      # Add a cattle type column with the cattle counts
      thisdt$emu = c(input$emu1,input$emu2,input$emu3,input$emu4)
      # Add a cattle type column with the cattle counts
      thisdt$pig = c(input$pig1,input$pig2,input$pig3,input$pig4)
      # Add a cattle type column with the cattle counts
      thisdt$kangaroo = c(input$kangaroo1,input$kangaroo2,input$kangaroo3,input$kangaroo4)
      
      # Tracks etc.
      thisdt$track = c("Track" %in% input$trackPresent1,"Track" %in% input$trackPresent2,"Track" %in% input$trackPresent3,"Track" %in% input$trackPresent4)
      thisdt$scald = c("Scald" %in% input$trackPresent1,"Scald" %in% input$trackPresent2,"Scald" %in% input$trackPresent3,"Scald" %in% input$trackPresent4)
      thisdt$scrape = c("Scrape" %in% input$trackPresent1,"Scrape" %in% input$trackPresent2,"Scrape" %in% input$trackPresent3,"Scrape" %in% input$trackPresent4)
      
      # Notes
      
      thisdt$note1 = input$note1
      thisdt$note2 = input$note2
      thisdt$note3 = input$note3
      thisdt$note4 = input$note4
      
      thisdt$Done = TRUE
      txseq = c("b1","b2","b3","b4")

      
      theid = data$thispt$ID[1]
      data$class_fr$Done[data$class_fr$ID == theid]=TRUE
      if(test == TRUE){
        write.csv(data$class_fr,"data/photo_temp.csv",row.names = FALSE)
      }else{
        write.csv(data$class_fr,"data/photos_order.csv",row.names = FALSE)
      }
      if(file.exists("data/output.csv")){
        write.table(thisdt,"data/output.csv",append=TRUE,col.names = FALSE,sep=",",row.names = FALSE)
      }else{
        write.csv(thisdt,"data/output.csv",row.names = FALSE)
      }
      
      print(thisdt)
    }
    
    # Prepare for next image
    
    print("next image")
    
    # Reset veg types
    updateSelectInput(session,"vegType","Majority Photo Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                             "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                             "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                             "Sandstone Heath"="Sandstone Heath",
                                                                             "Sandstone Woodland"="Sandstone Woodland",
                                                                             "Mangrove/Mud"="Mangrove/Mud",
                                                                             "Water/Bare"="Water/Bare",
                                                                             "Treeless"="Treeless",
                                                                             "Rocks"="Rocks"))
    updateSelectInput(session,"vegType1","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"))
    updateSelectInput(session,"vegType2","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"))
    updateSelectInput(session,"vegType3","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"))
    updateSelectInput(session,"vegType4","Quadrat Veg Class",choices=c("Euc Open Forest"="Euc Open Forest",
                                                                       "Euc Woodland (Mafic)"="Euc Woodland (Mafic)",
                                                                       "Euc Woodland (Sand)"="Euc Woodland (Sand)",
                                                                       "Sandstone Heath"="Sandstone Heath",
                                                                       "Sandstone Woodland"="Sandstone Woodland",
                                                                       "Mangrove/Mud"="Mangrove/Mud",
                                                                       "Water/Bare"="Water/Bare",
                                                                       "Treeless"="Treeless",
                                                                       "Rocks"="Rocks"))
    
    ### Update animals:
    updateTextInput(session,"cattle1","Cattle",value=0)
    updateTextInput(session,"donkey1","Donkeys",value=0)
    updateTextInput(session,"emu1","Emus",value=0)
    updateTextInput(session,"pig1","Pigs",value=0)
    updateTextInput(session,"kangaroo1","Kangaroo",value=0)
    updateTextInput(session,"cattle2","Cattle",value=0)
    updateTextInput(session,"donkey2","Donkeys",value=0)
    updateTextInput(session,"emu2","Emus",value=0)
    updateTextInput(session,"pig2","Pigs",value=0)
    updateTextInput(session,"kangaroo2","Kangaroo",value=0)
    updateTextInput(session,"cattle3","Cattle",value=0)
    updateTextInput(session,"donkey3","Donkeys",value=0)
    updateTextInput(session,"emu3","Emus",value=0)
    updateTextInput(session,"pig3","Pigs",value=0)
    updateTextInput(session,"kangaroo3","Kangaroo",value=0)
    updateTextInput(session,"cattle4","Cattle",value=0)
    updateTextInput(session,"donkey4","Donkeys",value=0)
    updateTextInput(session,"emu4","Emus",value=0)
    updateTextInput(session,"pig4","Pigs",value=0)
    updateTextInput(session,"kangaroo4","Kangaroo",value=0)
    
    # Update tracks:
    updateCheckboxGroupInput(session,"trackPresent1","Animal Track Present",
                       choices=c("Track"="Track",
                                 "Camp"="Camp",
                                 "Digging"="Digging"))
    updateCheckboxGroupInput(session,"trackPresent2","Animal Track Present",
                       choices=c("Track"="Track",
                                 "Camp"="Camp",
                                 "Digging"="Digging"))
    updateCheckboxGroupInput(session,"trackPresent3","Animal Track Present",
                       choices=c("Track"="Track",
                                 "Camp"="Camp",
                                 "Digging"="Digging"))
    updateCheckboxGroupInput(session,"trackPresent4","Animal Track Present",
                       choices=c("Track"="Track",
                                 "Camp"="Camp",
                                 "Digging"="Digging"))
    
    
    
    # Grab a subset of photos that haven't been done
    data$upto=ifelse(nrow(subset(data$class_fr,Done==TRUE))>0,max(subset(data$class_fr,Done==TRUE)$order)+1,1)
    print(data$upto)
    # Put the data for the selected row in the in the data$thispt object
    data$thispt=data$class_fr[data$class_fr$order == data$upto,]
    # Print the photo location to log
    print(data$thispt$PhotoLocation)
  })
  
  output$thisFilename <- renderText(data$thispt$PhotoLocation)
  output$thisVegclass <- renderText(data$thispt$VegID)
  
  output$preImage <-  renderImage({
    print(paste0("D:\\",data$thispt$PhotoLocation))
    frink = image_read(paste0("D:\\",data$thispt$PhotoLocation))
    #print(pht)
    # Read myImage's width and height. These are reactive values, so this
    # expression will re-run whenever they change.
    width  <- 1200
    height <- 800

    # For high-res displays, this will be greater than 1
    pixelratio <- session$clientData$pixelratio
    
    # A temp file to save the output.
    outfile <- tempfile(fileext='.png')

    
    f2=image_crop(frink, "5576x3884+500+250")
    f2=image_scale(f2,"1200")
    image_write(f2,outfile)
    template=image_read("template.png")
    f2=image_read(outfile)
    f3=c(template,f2,template)
    f4=image_flatten(f3)
    image_write(f4,outfile)
    
    # Return a list containing the filename
    list(src = outfile,
         width = width,
         height = height,
         alt = "This is alternate text")
  }, deleteFile = TRUE)
  
  output$mymap <- renderLeaflet({
    mapdata = data$thispt
    print(mapdata)
    coordinates(mapdata)=c("lon","lat")
    proj4string(mapdata)="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
    
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery",
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = mapdata)
  })

})
