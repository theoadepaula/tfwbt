## code to prepare `reservatorios_pe` dataset goes here

url_geral_pe <- 'https://www.apac.pe.gov.br/rios-e-reservatorios'

geral_pe <- xml2::read_html(url_geral_pe)

reservatorios_pe <-
  geral_pe %>%
  xml2::xml_find_all('//div/table//a[contains(@href,"Reservatorios")]') %>%
  xml2::xml_attr('href') %>%
  str_c('https://www.apac.pe.gov.br',.) %>%
  map_dfr(get_data_pe)

reservatorios_pe <- reservatorios_pe %>%
  distinct(reservatorio,data,.keep_all = TRUE)

usethis::use_data(reservatorios_pe, overwrite = TRUE)
