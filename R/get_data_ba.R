#' get_data_ba
#'
#' @param url string
#'
#' @return Tibble
#' @export
#'
#' @examples
#' \dontrun{
#' get_data_ba('https://www.encurtador.com.br/rtvOT')
#' }
get_data_ba <- function(url) {

  texto_pdf <- pdftools::pdf_text(url)

  tab_bruta_ba <- purrr::map_dfr(texto_pdf,pdf_to_ba)

  tab_clean_ba <-
    tab_bruta_ba %>%
      dplyr::mutate(
        cota_minima_operacional_m=dplyr::na_if(cota_minima_operacional_m,'SI'),
        dplyr::across(c(cota_maxima_operacional_m,
                        cota_minima_operacional_m,
                        volume_maximo_operacional_hm_3,
                        cota_atual_m,
                        volume_atual_hm_3,
                        volume_util_percent),
                      ~readr::parse_number(.x,
                                           locale = readr::locale(decimal_mark = ',',
                                                                  grouping_mark = '.'))),
        data=lubridate::dmy(data)
      )


  return(tab_clean_ba)

}
utils::globalVariables(c("cota_maxima_operacional_m",
                         'cota_minima_operacional_m',
                         "volume_maximo_operacional_hm_3",
                         "cota_atual_m",
                         'volume_atual_hm_3',
                         'volume_util_percent',
                         'data'))
