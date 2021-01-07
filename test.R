## ----GlobalOptions------------------------------------------------------------
  
  # Enables using readLines(knitr::purl(knitr::current_input(),documentation=1,quiet=T)) to include code at end of document (otherwise 'duplicate labels' error)

  options(knitr.duplicate.label = 'allow')



## ----setup--------------------------------------------------------------------

  packages <- c("base"
                , "tidyverse"
                , "bookdown"
                , "knitr"
                #, "kableExtra"
                , "devtools"
                , "fastcluster"
                , "cluster"
                , "randomForest"
                )

  purrr::walk(packages,library,character.only=TRUE)
  
  write_bib(packages,"packageCitations.bib")
  
  refs <- bib2df::bib2df("packageCitations.bib")
  
  cite_package <- function(package,brack = TRUE,startText = "", endText = "") {
    
    thisRef <- refs %>%
      dplyr::filter(grepl(paste0("-",package),BIBTEXKEY) | grepl(paste0("^",package),BIBTEXKEY)) %>%
      dplyr::pull(BIBTEXKEY)
    
    starts <- if(brack) paste0("[",startText,"@") else paste0(startText,"@")
    ends <- if(brack) paste0(endText,"]") else endText
    
    if(length(thisRef) > 1) {
      
      paste0(starts,paste0(thisRef,collapse = "; @"),ends)
      
      } else {
        
        paste0(starts,"R-",package,ends)
        
        }
    
  }



## ----chunk1, fig.cap = "Figure 1 caption"-------------------------------------

  plot(cars[,1:2])



## ----chunk2, fig.cap = "Figure 2 caption"-------------------------------------

  plot(iris[,3:4])



## ----chunk3-------------------------------------------------------------------
  iris %>%
    dplyr::mutate(Species = if_else(Species == "setosa"
                                    , paste0("*_",Species,"_")
                                    , as.character(Species)
                                    )
                  ) %>%
    kable(caption = "Ecosystem description: floristics"
          , format = "markdown"
          , booktabs = TRUE
          )



## ----code, code = readLines(knitr::purl(knitr::current_input(),documentation=1,quiet=T)), echo = TRUE, eval=FALSE----
## 
## # Need to include options(knitr.duplicate.label = "allow") prior to knitting.
## 
## # From https://github.com/yihui/knitr/issues/332
## 


## ----packages-----------------------------------------------------------------

  kable(tibble(package = packages) %>%
          dplyr::mutate(citation = map_chr(package,cite_package,brack = FALSE)) %>%
          dplyr::left_join(as_tibble(devtools::session_info(include_base = TRUE)$packages)) %>%
          dplyr::select(package,citation,loadedversion,date,source)
        , caption = paste0("R "
                           , cite_package("base")
                           , " packages used in the production of this report"
                           )
        )


