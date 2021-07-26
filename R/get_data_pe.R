#' Get Data Pe
#'
#' @param url_pe string
#'
#' @return tibble
#' @export
#'
#' @examples
#' \dontrun{get_data_pe('https://www.encurtador.com.br/giwE6')
#' }
#'
get_data_pe <- function(url_pe) {

  texto_pdftools <- pdftools::pdf_text(url_pe)

  reservatorio_pe <- purrr::map_dfr(texto_pdftools,pdf_tb_pe,.id = 'pag')

  reservatorio_pe %>%
    dplyr::mutate(data=lubridate::dmy(data),
                  dplyr::across(c(capacidade_maxima_10_3_m_3,cota_m,
                    percent_volume,volume_10_3_m_3),
                  ~readr::parse_number(.x,locale = readr::locale(decimal_mark = ",",
                                                   grouping_mark = "."))
           ))
}

utils::globalVariables(c("data", "capacidade_maxima_10_3_m_3", "cota_m",
                         'percent_volume','volume_10_3_m_3'))
