pdf_to_se <- function(texto_reservatorio_se,ano_arquivo) {

  texto_bruto <- texto_reservatorio_se %>%
    stringr::str_split('\n') %>%
    purrr::pluck(1) %>%
    tibble::tibble(texto=.) %>%
    dplyr::filter(stringr::str_detect(texto,''),
                  stringr::str_detect(texto,
                                      'Barragem|Data|Cota|Vol\\. \\u00datil \\(hm\\u00b3\\)|Volume \\u00datil \\(%\\)')) %>%
    dplyr::mutate(texto=stringr::str_trim(texto,'both'),
                  coluna=stringr::str_extract(texto,
                                              'Barragem|Data|Cota|Vol\\. \\u00datil \\(hm\\u00b3\\)|Volume \\u00datil \\(%\\)'),
                  grupo=ceiling(dplyr::row_number()/5))

  nmax <- suppressWarnings(max(stringr::str_count(texto_bruto$texto, "\\s{2,}"))) + 1

  texto_bruto %>%
    dplyr::group_split(grupo) %>%
    purrr::map(function(x){
      parte_dados <-  x %>%
        dplyr::filter(coluna !='Barragem') %>%
        dplyr::select(texto) %>%
        dplyr::mutate(texto=stringr::str_remove_all(texto,'\uf0ad|\uf0af')) %>%
        tidyr::separate(texto,sep='\\s{2,}',
                 into = paste0("col", seq_len(nmax)),
                 extra = 'merge'
                 ) %>%
        tidyr::pivot_longer(-col1) %>%
        tidyr::pivot_wider(names_from=col1, values_from=value) %>%
        janitor::clean_names() %>%
        dplyr::select(-name) %>%
        dplyr::na_if('-') %>%
        dplyr::na_if('RESE') %>%
        dplyr::mutate(data=lubridate::dmy(stringr::str_c(data,ano_arquivo)),
                      dplyr::across(cota:volume_util_percent,
                                    ~readr::parse_number(.x,
                                                  locale=readr::locale(decimal_mark =','))
                      )
        )

      nome_barragem <- x %>%
        dplyr::filter(coluna=='Barragem') %>%
        dplyr::pull(texto)

      parte_dados %>%
        dplyr::mutate(texto=nome_barragem) %>%
        tidyr::separate(texto,c('reservatorio','municipio'),
                sep=' \\– ',
                fill = 'right')

    }) %>%
    dplyr::bind_rows()

}

utils::globalVariables(c("grupo",
                         'coluna',
                         'col1',
                         'value',
                         'name'))

