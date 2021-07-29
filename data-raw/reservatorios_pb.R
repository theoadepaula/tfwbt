## code to prepare `reservatorios_pb` dataset goes here

tabela_ano <- tibble(ano=1960:2021,meses=list(1:12)) %>%
  unnest(meses)

pegar_dados_mensais_pb <- function(x,y){

  url <- paste0('http://www.aesa.pb.gov.br/aesa-website/resources/data/volumeAcudes/mensal/',x,'/',y,'/data.json')

  page_url<- GET(url)

  page_url %>%
    content('parsed',simplifyDataFrame=T) %>%
    tibble()

}

maybe_pegar_dados_mensais_pb <- possibly(pegar_dados_mensais_pb,tibble())

reservatorios_pb <- map2_dfr(tabela_ano$ano,tabela_ano$meses,
                             maybe_pegar_dados_mensais_pb)

reservatorios_pb <- reservatorios_pb %>%
  tidyr::unnest_wider(data,
                      names_sep = c('vt','va','data'),
                      names_repair = 'universal') %>%
  dplyr::rename('Volume Total %'=datavt1,
                'Volume Atual (m3)'=datava2,
                'Data'=datadata3) %>%
  janitor::clean_names()

reservatorios_pb <- reservatorios_pb %>%
  filter(!is.na(data))

usethis::use_data(reservatorios_pb, overwrite = TRUE)
