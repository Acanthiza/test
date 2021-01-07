  
  library(tidyverse)
  library(formattable)
  library(htmltools)
  library(htmlwidgets)
  library(webshot)
  
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
                  , Year = paste0("Year",2010 + sort(rep.int(1:10,10)))
                  , value = round(value,2)
                  ) %>%
    tidyr::spread(Year,value)
  
  #------formattable--------
  
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
  
  
  temp %>%
    formattable(list(area(col = 2:10) ~colProp)) %>%
    kableExtra::kable("html",escape = F) %>%
    kableExtra::column_spec(column = 1, width_min = "3cm") %>%
    kableExtra::kable_styling()
    
  
  #-----kableExtra-------
  temp %>%
    dplyr::mutate_at(2:ncol(.)
                     , ~kableExtra::cell_spec(.x
                                              , background = ifelse(.x<=0.2
                                                             , "green"
                                                             , ifelse(.x<=0.5
                                                                      , "orange"
                                                                      , ifelse(.x<=0.8
                                                                               , "red"
                                                                               , "black"
                                                                               )
                                                                      )
                                                             )
                                              )
                     ) %>%
    kableExtra::kable(escape = F) %>%
    kableExtra::column_spec(column = 1, width_min = "3cm") %>%
    kableExtra::kable_styling()
    
  
  #------gt-------
  temp %>%
    gt::gt() %>%
    gt::tab_style(style = cell_fill(color = "green")
                  , locations = cells_body(columns = 2:ncol(.)
                                           , rows = num < 0.2 & num >= 0 
                                           )
                  )
  