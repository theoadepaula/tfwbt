get_data_ce <- function() {

  url_ce <- 'http://www.funceme.br/produtos/script/acudes_e_rios/Boletim_diario_nivel_acudes/anos/atual/index.xml?'


  get_teste <- httr::GET(url_ce,
                   query=list('_'=as.POSIXct(Sys.time()) %>% as.integer()))

  tab_teste <- get_teste %>%
    httr::content('parsed',encoding = 'UTF-8')

  tab_ce <- tab_teste %>%
    XML::xmlParse() %>%
    XML::xmlRoot() %>%
    XML::getNodeSet('//sessao[1]//item') %>%
    XML::xmlToDataFrame()

  tab_ce_clean <-tab_ce %>%
    dplyr::select(acude:data,cota:lat,volume_m,volume_pc) %>%
    dplyr::mutate(data=lubridate::dmy(data),
           uf='CE',
           dplyr::across(cota:volume_pc,as.numeric)) %>%
    dplyr::relocate(uf) %>%
    tibble::tibble()

  return(tab_ce_clean)

}

utils::globalVariables(c("acude", "data",
                         "cota",'lat',
                         'volume_m','volume_pc'))
