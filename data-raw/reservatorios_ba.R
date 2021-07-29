## code to prepare `reservatorios_ba` dataset goes here

site_ba <- "http://www.inema.ba.gov.br/gestao-2/barragensreservatorios/informativo-semanal-de-monitoramento-das-barragens/"
page_ba <- xml2::read_html(site_ba)

links_page_ba <-
page_ba %>%
  xml2::xml_find_all("//div[@class='conteudo']//a") %>%
  xml2::xml_attr("href")

links_page_ba_xlsx <- links_page_ba %>%
  str_subset('\\.pdf',negate = TRUE)

links_page_ba <- links_page_ba %>%
  str_subset('\\.pdf')



maybe_get_data_ba <- possibly(get_data_ba,tibble())

reservatorios_ba_1 <- purrr::map_dfr(links_page_ba[210:239],get_data_ba)

reservatorios_ba_1 <- reservatorios_ba_1 %>%
  mutate(data=if_else(is.na(data),as.Date('2021-02-15'),data))

reservatorios_ba_1 <- reservatorios_ba_1 %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_2 <- purrr::map_dfr(links_page_ba[1:53],get_data_ba)

reservatorios_ba_2 <- reservatorios_ba_2 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_3 <- purrr::map_dfr(links_page_ba[54:105],get_data_ba)

reservatorios_ba_3 <- reservatorios_ba_3 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_4 <- purrr::map_dfr(links_page_ba[106:157],get_data_ba)

reservatorios_ba_4 <- reservatorios_ba_4 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_5 <- purrr::map_dfr(links_page_ba[158:170],get_data_ba)

reservatorios_ba_5 <- reservatorios_ba_5 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_6 <- purrr::map_dfr(links_page_ba[171:190],get_data_ba)

reservatorios_ba_6 <- reservatorios_ba_6 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

reservatorios_ba_7 <- purrr::map_dfr(links_page_ba[191:208],get_data_ba)

reservatorios_ba_7 <- reservatorios_ba_7 %>%
  filter(!is.na(reservatorio)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

GET(links_page_ba_xlsx,
    httr::write_disk(paste0('inst/extdata/',basename(links_page_ba_xlsx))))

library(readxl)

is40200 <- readxl::read_excel("inst/extdata/INFORMATIVO-SEMANAL-Nº40-2020.xlsx",
                              skip = 6) %>%
  janitor::clean_names()

is40200 <- is40200 %>%
  drop_na(nome_da_barragem)

pacman::p_load(unheadr)

reservatorios_ba_1 %>%
  glimpse()

reservatorios_ba_8 <- is40200 %>%
  untangle2('^BACIA|REGIÃO',nome_da_barragem,bacia) %>%
  drop_na(municipio) %>%
  select(-municipio,-operador,-c(usos:bacia)) %>%
  rename(reservatorio=nome_da_barragem) %>%
  mutate(across(cota_maxima_operacional_m:volume_maximo_operacional_hm3,
         parse_number))

reservatorios_ba <- bind_rows(reservatorios_ba_1,
                              reservatorios_ba_2,
                              reservatorios_ba_3,
                              reservatorios_ba_4,
                              reservatorios_ba_5,
                              reservatorios_ba_6,
                              reservatorios_ba_7,
                              reservatorios_ba_8) %>%
  drop_na(reservatorio) %>%
  distinct(reservatorio,data,.keep_all = TRUE)


usethis::use_data(reservatorios_ba, overwrite = TRUE)
