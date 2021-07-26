#' Get Data Pb
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{get_data_pb()}
#'
get_data_pb <- function() {

  url_base_pb <- 'http://www.aesa.pb.gov.br/aesa-website/resources/data/volumeAcudes/ultimosVolumes/data.json?'

  get_pb <- httr::GET(url_base_pb,
                  query=list('_'=as.POSIXct(Sys.time()) %>% as.integer()))

  tab_pb <-
    suppressMessages(get_pb %>%
    httr::content(as = 'text') %>%
    jsonlite::fromJSON())


  tab_pb_clean <- tab_pb %>%
    tidyr::as_tibble() %>%
    tidyr::unnest_wider(data,
                        names_sep = c('vt','va','data'),
                        names_repair = 'universal') %>%
    dplyr::rename('Volume Total %'=datavt1,
                  'Volume Atual (m3)'=datava2,
                  'Data'=datadata3) %>%
    janitor::clean_names()

  tab_pb_clean %>%
    dplyr::mutate(
      dplyr::across(c(volume_total_percent,
                      volume_atual_m3),
                    as.numeric),
      data=lubridate::as_date(data)
    ) %>%
    dplyr::select(-dplyr::contains('lng'),
                  -dplyr::contains('lat'),
                  -eh_principal, -id)

}

utils::globalVariables(c("volume_total_percent", "volume_atual_m3",
                         "eh_principal",'id',
                         'volume_total_percent','datavt1',
                         'datava2','datadata3'))
