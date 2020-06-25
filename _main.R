## ----GlobalOptions-------------------------------------------------------
  
  # Enables using readLines(knitr::purl(knitr::current_input(),documentation=1,quiet=T)) to include code at end of document (otherwise 'duplicate labels' error)

  options(knitr.duplicate.label = 'allow')



## ----setup---------------------------------------------------------------
  
  library("tidyverse")
  library("bookdown")
  library("kableExtra")



## ----chunk1, fig.cap = "Figure 1 caption"--------------------------------

  plot(cars[,1:2])



## ----chunk2, fig.cap = "Figure 2 caption"--------------------------------

  plot(iris[,3:4])



## ----chunk3--------------------------------------------------------------
  iris %>%
    dplyr::mutate(Species = if_else(Species == "setosa"
                                    , paste0("\\*","_",Species,"_")
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

