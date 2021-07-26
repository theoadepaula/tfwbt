#' Get Data Mg
#'
#' @param url string
#'
#' @return tibble
#' @export
#'
#' @examples
#'
#' \dontrun{
#' get_data_mg('http://www.dig.org.br/noticia/Julho-2021-distrito-do-gorutuba/272')
#' }

get_data_mg <- function(url) {

  meses <- 1:12 %>% lubridate::month(label = T,abbr = F) %>%
    as.character()

  mes_link <- stringr::str_extract(stringr::str_to_lower(url),
                          paste0(meses,collapse = '|'))

  html_mg <- xml2::read_html(url)

  tab_bico_pedra <- html_mg %>%
    xml2::xml_find_all('//table[2]') %>% purrr::pluck(1) %>%
    rvest::html_table() %>%
    janitor::row_to_names(1) %>%
    tidyr::pivot_longer(-DATA,names_to='ano',
                 values_to = 'cota',
                 names_transform = list(ano = readr::parse_number)
    ) %>%
    dplyr::mutate(DATA=dplyr::if_else(DATA=='052','05',DATA)) %>%
    dplyr::transmute(data=stringr::str_c(ano,mes_link,DATA,sep =' '),
              cota=dplyr::if_else(cota=='-',NA_character_,cota),
              cota=readr::parse_number(cota,
                                locale=readr::locale(decimal_mark = ',')) %>%
                round(2)) %>%
    dplyr::filter(!stringr::str_detect(data,'2017 fevereiro 29')) %>%
    dplyr::mutate(data=lubridate::ymd(data)) %>%
    dplyr::arrange(data) %>%
    tidyr::drop_na(cota)


tab_bico_pedra %>%
  dplyr::left_join(cav_bico,by = "cota") %>%
  dplyr::mutate(reservatorio='Bico da Pedra',
         uf='MG')

}

utils::globalVariables(c("DATA", "ano", "cota",
                         'cav_bico'))
