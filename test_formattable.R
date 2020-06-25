  
  library(tidyverse)
  library(formattable)
  library(htmltools)
  library(htmlwidgets)
  
  export_formattable <- function(f, file, width = "100%", height = NULL,background = "white", delay = 0.2){
    
    w <- as.htmlwidget(f, width = width, height = height)
    path <- html_print(w, background = background, viewer = NULL)
    url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
    webshot(url
            , file = file
            , selector = ".formattable_widget"
            , delay = delay
            )
    
    }
  
  temp <- tibble::enframe(sample(1:1000,100,replace=TRUE)/1000,name=NULL) %>%
    dplyr::mutate(Site = rep(1:10,10)
                  , Year = paste0("Year",2010 + sort(rep.int(1:10,10)))) %>%
    tidyr::spread(Year,value)
  
  
  
  
  
  colProp <- formatter("span"
                       , style = x ~ ifelse(x<=0.2
                                            , " background:green"
                                            , ifelse(x<=0.5
                                                     , " background:orange"
                                                     , ifelse(x<=0.8
                                                              , " background:red"
                                                              , " background:black"
                                                              )
                                                     )
                                            )
                       )
  
  
  
  formattable(temp
              , list(area(col = 2:10) ~colProp)
              ) %>%
    export_formattable("test_formattable.png")
  