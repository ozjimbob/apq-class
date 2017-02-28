## GpsPlot
library(mapview)
library(sp)
library(maptools)
library(geosphere)

data = read.csv("D:\\2016-06-18\\2016-06-18--07-26-30.736_gps.txt",header=FALSE,stringsAsFactors=FALSE)
drive="D:\\"
froot = "2016-06-18\\"
root=paste0(drive,froot)

names(data)=c("pid","lat","lon","V4","V5","UTMTime","V7","V8","V9")

data$UTMTime =  as.POSIXct(paste0(substr(data$UTMTime,2,11)," 2016",substr(data$UTMTime,12,25)),format="%a %b %d %Y %H:%M:%S",tz="GMT")

data$PhotoTime = as.POSIXct(format(data$UTMTime,tz="Australia/West"),tz="Australia/West")

data$PhotoLocation = ""
data$bearing = 0


#for(i in seq_along(data$PhotoTime)){
for(i in seq_along(data$PhotoLocation)){
  this_pt = data$PhotoTime[i]
  this_dir = paste0(root,format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  sh_dhirdir = paste0(format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  this_photo = format(this_pt,"%Y-%m-%d--%H-%M-%S")
  check_dir = list.files(this_dir,pattern=this_photo)
  if(length(check_dir)>0){
   pre=c(data$lon[i-1],data$lat[i-1])
   post=c(data$lon[i+1],data$lat[i+1])
   data$bearing[i] = bearing(pre,post) %% 360
   data$PhotoLocation[i]=paste0(froot,sh_dhirdir,check_dir[1])
    
  }
}

data=subset(data,PhotoLocation!="")
cdata = data


data = read.csv("D:\\2016-06-17\\2016-06-17--07-28-45.084_gps.txt",header=FALSE,stringsAsFactors=FALSE)
drive="D:\\"
froot = "2016-06-17\\"
root=paste0(drive,froot)

names(data)=c("pid","lat","lon","V4","V5","UTMTime","V7","V8","V9")

data$UTMTime =  as.POSIXct(paste0(substr(data$UTMTime,2,11)," 2016",substr(data$UTMTime,12,25)),format="%a %b %d %Y %H:%M:%S",tz="GMT")

data$PhotoTime = as.POSIXct(format(data$UTMTime,tz="Australia/West"),tz="Australia/West")

data$PhotoLocation = ""
data$bearing = 0


#for(i in seq_along(data$PhotoTime)){
for(i in seq_along(data$PhotoLocation)){
  this_pt = data$PhotoTime[i]
  this_dir = paste0(root,format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  sh_dhirdir = paste0(format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  this_photo = format(this_pt,"%Y-%m-%d--%H-%M-%S")
  check_dir = list.files(this_dir,pattern=this_photo)
  if(length(check_dir)>0){
    pre=c(data$lon[i-1],data$lat[i-1])
    post=c(data$lon[i+1],data$lat[i+1])
    data$bearing[i] = bearing(pre,post) %% 360
    data$PhotoLocation[i]=paste0(froot,sh_dhirdir,check_dir[1])
    
  }
}

data=subset(data,PhotoLocation!="")

cdata=rbind(data,cdata)


###########
data = read.csv("D:\\2016-06-17\\15\\48\\2016-06-17--15-48-19.276_gps.txt",header=FALSE,stringsAsFactors=FALSE)
drive="D:\\"
froot = "2016-06-17\\"
root=paste0(drive,froot)

names(data)=c("pid","lat","lon","V4","V5","UTMTime","V7","V8","V9")

data$UTMTime =  as.POSIXct(paste0(substr(data$UTMTime,2,11)," 2016",substr(data$UTMTime,12,25)),format="%a %b %d %Y %H:%M:%S",tz="GMT")

data$PhotoTime = as.POSIXct(format(data$UTMTime,tz="Australia/West"),tz="Australia/West")

data$PhotoLocation = ""
data$bearing = 0


#for(i in seq_along(data$PhotoTime)){
for(i in seq_along(data$PhotoLocation)){
  this_pt = data$PhotoTime[i]
  this_dir = paste0(root,format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  sh_dhirdir = paste0(format(this_pt,"%H"),"\\",format(this_pt,"%M"),"\\")
  this_photo = format(this_pt,"%Y-%m-%d--%H-%M-%S")
  check_dir = list.files(this_dir,pattern=this_photo)
  if(length(check_dir)>0){
    pre=c(data$lon[i-1],data$lat[i-1])
    post=c(data$lon[i+1],data$lat[i+1])
    data$bearing[i] = bearing(pre,post) %% 360
    data$PhotoLocation[i]=paste0(froot,sh_dhirdir,check_dir[1])
    
  }
}

data=subset(data,PhotoLocation!="")

cdata=rbind(data,cdata)





###########







copydata = cdata

coordinates(cdata)=c("lon","lat")
proj4string(cdata)="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
mapview(cdata)

copydata$V7 <- NULL
copydata$V8 <- NULL
copydata$V9 <- NULL
copydata$ID = seq_along(copydata$pid)
copydata$V5 <- NULL
names(copydata)[4] = "Altitude"

write.csv(copydata,"E:\\apq-class\\data\\photos.csv")
