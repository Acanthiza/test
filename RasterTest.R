
  library(tidyverse)
  library(raster)
  library(rasterVis)
  library(fs)
  
  setGroup <- 14
  useCores <- round(parallel::detectCores()*3/4,0)
  outDir <- here::here()
  
  

  r <- raster(nrows=100, ncols=100)
  r[] <- round(runif(ncell(r), 1, setGroup),0)
  plot(r)
  
  # rcl <- cbind(seq(from = 0, to = setGroup-1, by = 1)
  #              , seq(from = 2, to = setGroup+1, by = 1)
  #              , rep(0,setGroup)
  #              )
  
  
  beginCluster(useCores)
  
  for(i in 1:setGroup) {
    
    rcl <- cbind(c(0,i-1,i),c(i-1,i,setGroup),c(0,1,0))
    
    clusterR(r
             , reclassify
             , args=list(rcl = rcl, right = FALSE)
             #, export = c(i, r, rcl)
             , filename = paste0(outDir,"/ecosystem_",i,".tif")
             , overwrite = TRUE
             , progress = "text"
             )
    
  }
  
  endCluster()
  
  brick <- dir_info(here::here()) %>%
    dplyr::filter(grepl("tif$",path)) %>%
    dplyr::mutate(raster = map(path,raster)) %>%
    dplyr::pull(raster) %>%
    brick()
  
  levelplot(brick)
  