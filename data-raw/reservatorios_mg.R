## code to prepare `reservatorios_mg` dataset goes here
url_mg <- 'http://www.dig.org.br/pagina_01/noticias'

html_mg_geral <- xml2::read_html(url_mg)

meses <- 1:12 %>% lubridate::month(label = T,abbr = F) %>%
  as.character()

links_dados_cota_mg <- html_mg_geral %>%
  xml2::xml_find_all('//div[@class="conteudo"]//a') %>%
  xml2::xml_attr('href') %>%
  str_to_lower() %>%
  tibble(links=.) %>%
  filter(str_detect(links,paste0(meses,collapse = '|')),
         !str_detect(links,'lei')) %>%
  pull(links)

maybe_get_data_mg=possibly(get_data_mg,tibble())


reservatorios_mg <- map_dfr(links_dados_cota_mg,maybe_get_data_mg) %>%
  distinct(data,.keep_all = TRUE) %>% arrange(data)

usethis::use_data(reservatorios_mg, overwrite = TRUE)
