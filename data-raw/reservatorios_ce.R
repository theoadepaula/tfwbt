## code to prepare `reservatorios_ce` dataset goes here

reservatorios_ce <- get_data_ce()


usethis::use_data(reservatorios_ce, overwrite = TRUE)
