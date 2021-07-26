## code to prepare `cav_bico` dataset goes here

cav_bico <- suppressMessages(
  readr::read_csv2(
    here::here('inst/extdata/cota_volume_bico_pedra.csv'),
    col_types = readr::cols(cota='d',
                            area_ha='d',
                            volume_hm3='d')
  )
)

usethis::use_data(cav_bico, overwrite = TRUE)
