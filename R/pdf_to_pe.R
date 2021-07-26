pdf_tb_pe <- function(texto) {


  texto_sep <- texto%>%
    stringr::str_split('\n')

  texto_sep%>%
    purrr::pluck(1) %>%
    tibble::tibble(texto=.)  %>%
    dplyr::filter(stringr::str_detect(texto,''),
                  !stringr::str_detect(texto,'^\\s+|\\*|^Legenda'),
    ) %>%
    tidyr::separate(texto,
                    c('RESERVATORIO','MUNICIPIO','CAPACIDADE MAXIMA (10_3_m_3)',
                      'DATA','COTA (m)','VOLUME (10_3_m_3)','% VOLUME',
                      'ABERTURA','SITUACAO','Variacao do Volume (10_3_m_3)'),
                    sep='\\s{2,}') %>%
    janitor::clean_names()
}

utils::globalVariables(c("...1"))
