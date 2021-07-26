## code to prepare `reservatorios_se` dataset goes here

url_se <- 'https://sedurbs.se.gov.br/portalrecursoshidricos/exec_procedure.php?nm_procedure=consultarBoletim&param_procedure=null%2C+1'

url_base_se <- 'https://sedurbs.se.gov.br/portalrecursoshidricos/gerenciamento/boletins_reservatorio/'

page_se <- httr::GET(url_se)

text_se <- page_se %>%
  content('text')


nome_arquivos_se <- text_se %>%
  jsonlite::fromJSON() %>%
  pull(arquivo)

links_reservatorios_se <- str_remove_all(nome_arquivos_se,'\t') %>%
  str_replace_all(' ','%20') %>%
  str_c(url_base_se,.)

maybe_get_data_se <- possibly(get_data_se,tibble::tibble())

reservatorios_se <- map_dfr(links_reservatorios_se,
                            maybe_get_data_se)

usethis::use_data(reservatorios_se, overwrite = TRUE)
