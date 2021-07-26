pdf_to_ba <- function(texto_bruto) {

  texto_bruto%>%
    stringr::str_split('\n') %>%
    purrr::pluck(1) %>%
    tibble::tibble(texto=.) %>%
    dplyr::filter(stringr::str_detect(texto,''),
                  stringr::str_detect(texto,'\\d+')) %>%
    dplyr::mutate(texto=stringr::str_replace(texto,
                                             paste0('\\s{2,}ITIUBA / ',
                                                    stringi::stri_unescape_unicode('CANSAN\\u00c7\\u00c3O')),
                                             paste0(stringi::stri_unescape_unicode('R\\u00d4MULO'),
                                                    ' CAMPOS (JACURICI)'))) %>%
    dplyr::filter(!stringr::str_detect(texto,'^\\s{2,}')) %>%
    dplyr::mutate(texto=stringr::str_remove(texto,'\\s{2,}\\D+'),
                  texto=stringr::str_remove_all(texto,'\\D+$')
    ) %>%
    tidyr::extract(texto,
                   c('reservatorio',
                     'cota maxima OPERACIONAL (m)',
                     'cota minima OPERACIONAL (m)',
                     'VOLUME MAXIMO OPERACIONAL (hm_3)',
                     'DATA','COTA ATUAL (m)',
                     'VOLUME ATUAL (hm_3)',
                     'VOLUME UTIL (%)'
                   ),
                   regex='(\\D+)(.*?)\\s{2,}(.*?)\\s{2,}(.*?)\\s{2,}(.*?)\\s{2,}(.*?)\\s{2,}(.*?)\\s{2,}(.*)') %>%
    janitor::clean_names()

}

utils::globalVariables(c("texto",
                         '.'))
