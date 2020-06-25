

  library(tidyverse)
  library(rstan)
  library(rstanarm)
  options(mc.cores = 5)
  
  dat <- bind_rows(lme4::sleepstudy
                   , tibble(Reaction = c(286, 288), Days = 0:1, Subject = "374")
                   , tibble(Reaction = 245, Days = 0, Subject = "373")
                   ) %>%
    as_tibble()
  
  ggplot(dat,aes(Days,Reaction)) + geom_point() + geom_smooth(method = "lm",se = FALSE) + facet_wrap(~Subject)

  mod <- stan_glmer(Reaction ~ Days + (Days|Subject)
                    , data = dat
                    , family = Gamma(link = "identity")
                    )
  
  df_posterior <- as_tibble(mod)
  
  df_effects <- df_posterior %>%
    dplyr::mutate_at(.vars = vars(matches("b\\[\\(Intercept"))
                     , .funs = funs(. + df_posterior$`(Intercept)`)
                     ) %>%
    dplyr::mutate_at(.vars = vars(matches("b\\[Day"))
                     , .funs = funs(. + df_posterior$Days)
                     )
  
  df_long_effects <- df_effects %>%
    select(matches("b\\[")) %>%
    rowid_to_column("draw") %>%
    tidyr::gather(param,value,-draw)
  
  df_long_effects$effect <- df_long_effects$param %>%
    stringr::str_detect("Intercept") %>%
    ifelse(.,"Intercept","Slope_Day")
  
  df_long_effects$Subject <- df_long_effects$param %>%
    stringr::str_extract("\\d\\d\\d")
  
  df_long_effects <- df_long_effects %>%
    dplyr::select(draw,Subject,effect,value)
  
  df_wide_effects <- df_long_effects %>%
    tidyr::spread(effect,value)
    
  
  ggplot(data = dat, aes(x = Days, y = Reaction)) +
    geom_abline(aes(intercept = Intercept,slope = Slope_Day)
                , data = df_wide_effects %>% dplyr::group_by(Subject) %>% dplyr::sample_n(100) %>% dplyr::ungroup()
                , alpha = 0.1
                ) +
    geom_point() +
    geom_smooth(method = "lm") +
    facet_wrap(~Subject)
  
  