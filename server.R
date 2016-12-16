
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jpeg)
library(sp)
library(maptools)

imglistdata = read.csv("data/photos.csv",stringsAsFactors=FALSE)
imglistdata$Done=FALSE

shinyServer(function(input, output,session) {
  
  data <- reactiveValues(
    class_fr = imglistdata,
    thispt = NULL
  )
  
  observeEvent( input$refresh,{
    
    if(!is.null(data$thispt)){
      thisdt=data$thispt
      thisdt$vegType = input$vegType
      thisdt = thisdt[rep(seq_len(nrow(thisdt)), each=6),]
      thisdt$SqID = 1:6
      thisdt$AnimalTrack = FALSE
      thisdt$Done = TRUE
      txseq = c("b1","b2","b3","b4","b5","b6")
      selw = which(txseq %in% input$trackPresent )
      if(length(selw)> 0){
        thisdt$AnimalTrack[selw]=TRUE
      }
      
      theid = data$thispt$ID[1]
      data$class_fr$Done[data$class_fr$ID == theid]=TRUE
      write.csv(data$class_fr,"data/photo_temp.csv")
      
      if(file.exists("data/output.csv")){
        write.table(thisdt,"data/output.csv",append=TRUE,col.names = FALSE,sep=",")
      }else{
        write.csv(thisdt,"data/output.csv")
      }
      
      print(thisdt)
    }
    
    
    print("next image")
    
    updateCheckboxGroupInput(session, "trackPresent","Animal Track Present",
                             choices=c("Box 1"="b1",
                                       "Box 2"="b2",
                                       "Box 3"="b3",
                                       "Box 4"="b4",
                                       "Box 5"="b5",
                                       "Box 6"="b6"))
    
    updateRadioButtons(session,"vegType","Majority Photo Veg Class",choices=c("Savanna"="Savanna",
                                                                "Swamp"="Swamp",
                                                                "Sandstone"="Sandstone",
                                                                "Water"="Water",
                                                                "Grass"="Grass")),
    
    sfr = subset(data$class_fr,Done==FALSE)
    selid = sample(sfr$ID,1)
    data$thispt=sfr[selid,]
    print(data$thispt$PhotoLocation)
  })
  
  output$preImage <-  renderImage({
    
    pht = readJPEG(paste0("D:\\",data$thispt$PhotoLocation))
    #print(pht)
    # Read myImage's width and height. These are reactive values, so this
    # expression will re-run whenever they change.
    width  <- 1200
    height <- 800

    # For high-res displays, this will be greater than 1
    pixelratio <- session$clientData$pixelratio
    
    # A temp file to save the output.
    outfile <- tempfile(fileext='.png')

    # Generate the image file
    png(outfile, width=width*pixelratio, height=height*pixelratio,
        res=72*pixelratio)
    par(mar=c(0,0,0,0))
    plot.new()
    plot.window(c(0,1),c(0,1))
    rasterImage(pht,0,0,1,1)
    
    rect(0,0,033,0.5,border="red",lwd=2)
    rect(0.33,0,0.67,0.5,border="red",lwd=2)
    rect(0.67,0,1,0.5,border="red",lwd=2)
    rect(0,0.5,033,1,border="red",lwd=2)
    rect(0.33,0.5,0.67,1,border="red",lwd=2)
    rect(0.67,0.5,1,1,border="red",lwd=2)
    
    text(0,0.45,label="4",col="red",pos=4,cex=2)
    text(0.33,0.45,label="5",col="red",pos=4,cex=2)
    text(0.67,0.45,label="6",col="red",pos=4,cex=2)
    text(0,0.95,label="1",col="red",pos=4,cex=2)
    text(0.33,0.95,label="2",col="red",pos=4,cex=2)
    text(0.67,0.95,label="3",col="red",pos=4,cex=2)
    
    dev.off()
    
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
