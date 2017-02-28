# sample points
library(sp)
library(maptools)
library(readr)
library(leaflet)

photos = read.csv("data/photos.csv")
photos$X = NULL

shp_photos=readShapePoints("data/photo_t/photos_wveg2.shp")

photos$TranID = shp_photos$transectID
photos$VegID = shp_photos$CFI_1
photos = subset(photos,TranID > 0)


#photosp = photos
#coordinates(photosp)=c("lon","lat")
#pal =colorRampPalette(c("red","yellow","green"))(17)
#m=leaflet(photosp) %>% addTiles()
#m %>% addCircles(lat=photos$lat,lng=photos$lon,color=pal[photos$TranID],radius=2)

#pal =colorRampPalette(c("red","yellow","green"))(5)
#m=leaflet(photosp) %>% addTiles()
#m %>% addCircles(lat=photos$lat,lng=photos$lon,color=pal[photos$VegID],radius=2)

plot(table(photos$VegID))
plot(table(photos$TranID))
plot(table(photos$VegID,photos$TranID))

photos$VegID=as.character(photos$VegID)
photos$VegID[photos$VegID == "<NA>" | photos$VegID=="n/a"]="NA"
photos=subset(photos,!is.na(VegID))


unq_veg = unique(photos$VegID)
unq_tran = unique(photos$TranID)

veg_ctr = 1
tran_ctr = 1
max_veg = length(unq_veg)
max_tran = length(unq_tran)
cplace = rep(veg_ctr,length(unq_tran))

photos$order=0

for(i in seq_along(photos$ID)){
  chosen = 0
  while(chosen==0){
    tsel = subset(photos,TranID == tran_ctr & order == 0)
    
    # We have found something in tran
    if(nrow(tsel)>0){
      chosen2=0
      ctr=1
      while(chosen2==0){
        print(paste0("Transect: ",tran_ctr," Veg: ", unq_veg[cplace[tran_ctr]]))
        tsel2 = subset(tsel,VegID == unq_veg[cplace[tran_ctr]])
        
        # We have found something in veg
        if(nrow(tsel2)>0){
          print("Veg found")
          cplace[tran_ctr]=cplace[tran_ctr]+1
          if(cplace[tran_ctr]>max_veg){
            cplace[tran_ctr]=1
          }
          tran_ctr=tran_ctr+1
          if(tran_ctr > max_tran){
            tran_ctr=1
          }
          chosen2=1
          chosen=1
        }else{
          # We haven't found something in veg
          cplace[tran_ctr]=cplace[tran_ctr]+1
          if(cplace[tran_ctr]>max_veg){
            cplace[tran_ctr]=1
          }
          ctr=ctr+1
          if(ctr>max_veg){
            chosen2=1
          }
        }

      }
      
      
    }else{
      # We haven't found something in veg, try next transect
      tran_ctr=tran_ctr+1
      if(tran_ctr > max_tran){
        tran_ctr=1
      }
    }
    if(nrow(tsel2)==0){
      tran_ctr=tran_ctr+1
      if(tran_ctr > max_tran){
        tran_ctr=1
      }
    }
    
  }
  
  if(nrow(tsel2)==1){
    p=tsel2$ID[1]
  }else{
  p=sample(tsel2$ID,1)
  }
  
  if(photos$order[photos$ID==p]!=0){
    print("Error:")
    break
  }
  photos$order[photos$ID==p]=i
  print(paste0("ID: ",p," Order: ",i," Transect: ",tran_ctr))
}


write.csv(photos,"data/photos_order.csv")
