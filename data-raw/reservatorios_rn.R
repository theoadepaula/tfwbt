## code to prepare `reservatorios_rn` dataset goes here

reservatorios_rn <- get_data_rn()

usethis::use_data(reservatorios_rn, overwrite = TRUE)
