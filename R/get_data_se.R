get_data_se <- function(url_se) {

  texto_reservatorio_se <- pdftools::pdf_text(url_se)

ano_arquivo <- basename(url_se) %>%
  stringr::str_extract('_(\\d+)\\.') %>% readr::parse_number()


purrr::map_dfr(texto_reservatorio_se,
        ~pdf_to_se(.x,ano_arquivo))

}
