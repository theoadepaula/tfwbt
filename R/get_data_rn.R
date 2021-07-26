#' Get Data RN
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{get_data_rn()}
#'

get_data_rn <- function() {
  site_rn="http://sistemas.searh.rn.gov.br/MonitoramentoVolumetrico/"

  pag_rn <- xml2::read_html(site_rn)

  nomes_regioes_rn <-   pag_rn %>%
    xml2::xml_find_all('//div/h3[contains(text(),"Bacia")]') %>%
    xml2::xml_text() %>%
    stringr::str_squish() %>%
    stringr::str_remove('.*?: ')


  rs_rn <-
    rvest::html_table(pag_rn) %>%
    purrr::map(~dplyr::slice(.x,1:dplyr::n()-1)) %>%
    purrr::set_names(nomes_regioes_rn) %>%
    dplyr::bind_rows(.id='bacia') %>%
    janitor::clean_names()

  rs_rn_clean <-
    rs_rn %>%
    dplyr::mutate(uf="RN",
                  data_da_medicao=lubridate::dmy(data_da_medicao),
                  dplyr::across(c(capacidade_m3, volume_atual_m3,volume_atual_percent),
                         ~readr::parse_number(.x,locale = readr::locale(decimal_mark = ",",
                                                          grouping_mark = "."))),
                  cota=0,
                  area=0,
                  volume_atual_hm3=volume_atual_m3/10^6,
                  reservatorio=stringr::str_squish(stringr::str_remove(reservatorio,"\\*| \\(CAV 2018\\)"))) %>%
    dplyr::relocate(volume_atual_hm3,.after=volume_atual_m3)

  rs_rn_clean %>%
    dplyr::relocate(uf,municipio,reservatorio,data_da_medicao)

}

utils::globalVariables(c("data_da_medicao", "capacidade_m3",
                         "volume_atual_m3",'volume_atual_percent',
                         'reservatorio','volume_atual_hm3',
                         'uf','municipio'))
