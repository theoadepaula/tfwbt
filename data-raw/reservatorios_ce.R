## code to prepare `reservatorios_ce` dataset goes here

pegar_dados_ce_2 <- function(url) {

  read_delim(url) %>%
    set_names(c('cod','acude','longe','lat','cota','volume_m','volume_pc')) %>%
    mutate(data=  basename(url) %>%
             str_remove_all('volumes_|.{4}$'))
  #%>%

}

links_volumes_ce <- c('http://www.funceme.br/produtos/script/acudes_e_rios/Series_diarias_nivel_acudes/volumes_2008.csv',
                      'http://www.funceme.br/produtos/script/acudes_e_rios/Series_diarias_nivel_acudes/volumes_2010.csv',
                      'http://www.funceme.br/produtos/script/acudes_e_rios/Series_diarias_nivel_acudes/volumes_20071231.csv',
                      'http://www.funceme.br/produtos/script/acudes_e_rios/Series_diarias_nivel_acudes/volumes_20091231.csv')

reservatorios_ce_2 <- map_dfr(links_volumes_ce,
        pegar_dados_ce_2)

reservatorios_ce_2_clean <- reservatorios_ce_2 %>%
  mutate(data=if_else(str_length(data)<5,str_c(data,'1231'),data),
         data=ymd(data))


reservatorios_ce <- reservatorios_ce %>%
  bind_rows(reservatorios_ce_2_clean %>% select(-cod))


reservatorios_ce <- reservatorios_ce %>%
  bind_rows(get_data_ce()) %>%
  distinct(acude,data,.keep_all = TRUE)



usethis::use_data(reservatorios_ce, overwrite = TRUE)
