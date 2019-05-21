
  library(tidyverse)
  library(raster)
  library(rasterVis)
  library(fs)
  library(rbenchmark)
  
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
  
  testReclass <- function(r,size) {
    
    start <- Sys.time()
      
      beginCluster(useCores)
      
      for(i in 1:setGroup) {
        
        rcl <- cbind(c(0,i-1,i),c(i-1,i,setGroup),c(0,1,0))
        
        clusterR(r
                 , reclassify
                 , args=list(rcl = rcl)
                 #, export = c(i, r, rcl)
                 , filename = paste0(outDir,"/ecosystem_",i,"_",size,".tif")
                 , overwrite = TRUE
                 , progress = "text"
        )
        
      }
      
      endCluster()
      
      Sys.time() - start
    
  }
  
  
  
  testBrick <- function(XbyY) {
    
    start <- Sys.time()
    
    brick <- dir_info(here::here()) %>%
      dplyr::filter(grepl(XbyY,path)) %>%
      dplyr::mutate(raster = map(path,raster)) %>%
      dplyr::pull(raster) %>%
      brick()
    
    write_rds(brick, paste0("brick_",XbyY,".rds"))
    
    Sys.time() - start
    
  }
  
  
  testLevelPlot <- function(b) {
    
    start <- Sys.time()
    
    levelplot(b)
    
    Sys.time() - start
    
  }
  
  
  
  
  # CLEANUP
  file_delete(grep("tif$|brick",dir_ls(here::here()),value=TRUE))
  
  
  results <- tribble(~x,~y,
                     100, 100,
                     200, 200,
                     400, 400,
                     800, 800,
                     1600, 1600,
                     3200, 3200
                     ) %>%
    dplyr::mutate(XbyY = paste0(x,"by",y)
                  , r = map2(x,y,~raster(ncol=.x,nrow=.y,vals = round(runif(.x*.y, 1, setGroup),0)))
                  , timeReclass = map2(r, XbyY, testReclass)
                  , timeBrick = map(XbyY,testBrick)
                  , brick = map(XbyY, ~read_rds(paste0("brick_",.,".rds")))
                  , timeLevelPlot = map(brick,testLevelPlot)
                  ) %>%
    tidyr::unnest(timeReclass,timeBrick,timeLevelPlot) %>%
    dplyr::mutate(time = Sys.time()
                  , os = Sys.info()["sysname"]
                  , release = Sys.info()["release"]
                  , cores = parallel::detectCores()
                  )
  
  write_csv(results %>% dplyr::select_if(Negate(is.list))
            ,"rasterTest.csv"
            ,append=TRUE
            )
  
  # CLEANUP
  file_delete(grep("tif$|brick",dir_ls(here::here()),value=TRUE))
  