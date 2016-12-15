
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jpeg)
imglist = list.files("E:\\photos\\",pattern="JPG",full.names=TRUE)

shinyServer(function(input, output,session) {

  output$preImage <-  renderImage({
    print("go")
    input$refresh
    
    timg = sample(imglist,1)
    pht = readJPEG(timg)
    
    # Read myImage's width and height. These are reactive values, so this
    # expression will re-run whenever they change.
    width  <- session$clientData$output_preImage_width
    height <- session$clientData$output_preImage_height
    print(width)
    print(height)
    
    # For high-res displays, this will be greater than 1
    pixelratio <- session$clientData$pixelratio
    
    # A temp file to save the output.
    outfile <- tempfile(fileext='.png')
    print(outfile)
    # Generate the image file
    png(outfile, width=width*pixelratio, height=height*pixelratio,
        res=72*pixelratio)
    par(mar=c(0,0,0,0))
    plot.new()
    plot.window(c(0,1),c(0,1))
    rasterImage(pht,0,0,1,1)
    
    dev.off()
    
    # Return a list containing the filename
    list(src = outfile,
         width = width,
         height = height,
         alt = "This is alternate text")
  }, deleteFile = TRUE)

})
