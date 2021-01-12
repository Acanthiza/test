## ----GlobalOptions------------------------------------------------------------
  
  # Enables using readLines(knitr::purl(knitr::current_input(),documentation=1,quiet=T)) to include code at end of document (otherwise 'duplicate labels' error)

  options(knitr.duplicate.label = 'allow')



## ----setup--------------------------------------------------------------------

  packages <- c("base"
                ,"tidyverse"
                ,"bookdown"
                ,"knitr"
                ,"fs"
                ,"devtools"
                ,"fastcluster"
                ,"cluster"
                ,"randomForest"
                ,"DBI"
                )

  purrr::walk(packages,library,character.only=TRUE)
  
  testUnderscore <- "Alinytjara Wilu\u1E5Fara"
  


## ----functions----------------------------------------------------------------

  #-------Load functions-------
    
  commonFiles <- path("..","template","toCommon")
  
  if(file.exists(commonFiles)){
    
    files <- dir_ls(commonFiles)
    newFiles <- files %>% gsub(commonFiles,path("common"),.)
    dir_create("common")
    walk2(files,newFiles,file_copy,overwrite=TRUE)
    
  }
  
  source("common/functions.R") # these are generic functions (e.g. vec_to_sentence)



## ----references---------------------------------------------------------------

#---------References-------
  
  packageBibFile <- "packageCitations.bib"
  
  write_bib(packages
            ,file=packageBibFile
            ,tweak=TRUE
            ,width=1000
            )
  
  refs <- fix_bib(packageBibFile,isPackageBib = TRUE)
  
  #fix_bib("common/refs.bib")



## ----chunk1, fig.cap = "Figure 1 caption"-------------------------------------

  plot(cars[,1:2])



## ----chunk2, fig.cap = "Figure 2 caption"-------------------------------------

  plot(iris[,3:4])



## ----chunk3-------------------------------------------------------------------
  iris %>%
    dplyr::sample_n(15) %>%
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


