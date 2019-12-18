createSubsets <- function(inputrst, targetsize, targetdir){
  #determine next number of quadrats in x and y direction, by simple rounding
  targetsizeX <- targetsize[1]
  targetsizeY <- targetsize[2]
  
  nsx <- round(ncol(inputrst) / targetsizeX)
  nsy <- round(nrow(inputrst) / targetsizeY)
  
  #determine quadrat size using rounded number of cells 
  aggfactorX <- ncol(inputrst)/nsx
  aggfactorY <- nrow(inputrst)/nsy
   
  
  #return (list(ssizeX = ssizeX, ssizeY = ssizeY, nsx = nsx, nsy =nsy))
  agg <- aggregate(inputrst[[1]],c(aggfactorX,aggfactorY))
  agg[]    <- 1:ncell(agg)
  agg_poly <- rasterToPolygons(agg)
  names(agg_poly) <- "polis"
  
  for(i in 1:ncell(agg)) {
    
   # rasterOptions(tmpdir=tmpdir)
    e1  <- extent(agg_poly[agg_poly$polis==i,])
    subs <- crop(inputrst,e1)
    writeRaster(subs,filename=paste0(targetdir,"SplitRas_",i,".grd"),overwrite=TRUE) 
   
  }
}

#############################
########alternative##########
#############################

createSubsets <- function(inputrst, targetsize, targetdir){
  #determine next number of quadrats in x and y direction, by simple rounding
  targetsizeX <- targetsize[1]
  targetsizeY <- targetsize[2]
  while(ncol(inputrst)%%targetsizeX!=0){
    targetsizeX= targetsizeX+1  
  }
  while(nrow(inputrst)%%targetsizeY!=0){
    targetsizeY= targetsizeY+1  
  }
  
  
  #nsx <- round(ncol(inputrst) / targetsizeX)
  #nsy <- round(nrow(inputrst) / targetsizeY)
  
  #determine quadrat size using rounded number of cells 
  #aggfactorX <- ncol(inputrst)/nsx
  #aggfactorY <- nrow(inputrst)/nsy
  
  
  #return (list(ssizeX = ssizeX, ssizeY = ssizeY, nsx = nsx, nsy =nsy))
  agg <- aggregate(inputrst[[1]],c(targetsizeX,targetsizeY))
  agg[]    <- 1:ncell(agg)
  agg_poly <- rasterToPolygons(agg)
  names(agg_poly) <- "polis"
  
  for(i in 1:ncell(agg)) {
    
    # rasterOptions(tmpdir=tmpdir)
    e1  <- extent(agg_poly[agg_poly$polis==i,])
    subs <- crop(inputrst,e1)
    writeRaster(subs,filename=paste0(targetdir,"SplitRas_",i,".grd"),overwrite=TRUE) 
    
  }
}





testrst <- stack("/home/rstudio/test/TrainData/image_tifs/Image_1.tif")

createSubsets(testrst,targetsize = c(128,128),targetdir = "C:/Users/c_knot03/sciebo/Deep learning R/R-Project/first_steps/TrainData/subsets/")


