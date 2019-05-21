
  library(tidyverse)
  library(raster)
  library(clusterR)
  
  setGroup <- 14
  useCores <- round(parallel::detectCores()*3/4,0)
  outDir <- here::here()
  
  

  r <- raster(nrows=100, ncols=100)
  r[] <- floor(runif(ncell(r), 1,setGroup))
  plot(r)
  
  rcl <- cbind(seq(1:setGroup),seq(1:setGroup),0)
  
  
  beginCluster(useCores)
  
  for(i in 1:setGroup) {
    
    rcl[i,3] <- 1
    
    clusterR(r
             , reclassify
             , args=list(rcl = rcl, right = NA)
             #, export = c(i, r, rcl)
             , filename = paste0(outDir,"/ecosystem_",i,".tif")
             , overwrite = TRUE
             , progress = "text"
             )
    
  }
  
  endCluster()