## code to prepare `reservatorios_ba` dataset goes here

site_ba <- "http://www.inema.ba.gov.br/gestao-2/barragensreservatorios/informativo-semanal-de-monitoramento-das-barragens/"
page_ba <- xml2::read_html(site_ba)

links_page_ba <-
page_ba %>%
  xml2::xml_find_all("//div[@class='conteudo']//a") %>%
  xml2::xml_attr("href")

reservatorios_ba <- purrr::map_dfr(links_page_ba,get_data_ba)

reservatorios_ba <-
  dplyr::distinct(reservatorios_ba,data,reservatorio,.keep_all = TRUE) %>%
  tidyr::drop_na(reservatorio)


usethis::use_data(reservatorios_ba, overwrite = TRUE)
