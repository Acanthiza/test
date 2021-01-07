## ----GlobalOptions------------------------------------------------------------
  
  # Enables using readLines(knitr::purl(knitr::current_input(),documentation=1,quiet=T)) to include code at end of document (otherwise 'duplicate labels' error)

  options(knitr.duplicate.label = 'allow')



## ----setup--------------------------------------------------------------------

  packages <- c("tidyverse"
                , "bookdown"
                , "kableExtra"
                , "knitcitations"
                , "devtools"
                )

  purrr::walk(packages,library,character.only=TRUE)
  
  cleanbib()
  
  options("citation_format" = "pandoc")



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
          dplyr::mutate(citation = map_chr(package,~citet(citation(.)))) %>%
          dplyr::left_join(as_tibble(session_info(include_base = TRUE)$packages)) %>%
          dplyr::select(package,citation,loadedversion,date,source)
        , caption = paste0("R "
                           , citep(citation("base"))
                           , " packages used in the production of this report"
                           )
        )



## ----references---------------------------------------------------------------

  knitcitations::write.bibtex(file="packageCitations.bib")


