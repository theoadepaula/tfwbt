## code to prepare `reservatorios_pe` dataset goes here


rD <- rsDriver(port = 4568L, browser = "chrome",
               #version = 'latest',
               chromever="92.0.4515.43",check = F,verbose=F)

remDr <- rD$client

remDr$open()

remDr$navigate('https://www.apac.pe.gov.br/rios-e-reservatorios')

buscao_avancada <- remDr$findElement(using = 'xpath', '//div[3]/div/div/p/a')

buscao_avancada$clickElement()

opt_reservatorio <- remDr$findElement(using = 'xpath', '//input[@id="content-101"]')
opt_reservatorio$click()

opt_de <- remDr$findElement(using = 'xpath','//input[@id="de"]')
opt_de$sendKeysToElement(list('01/01/2010'))
opt_de$click()

opt_para <- remDr$findElement(using = 'xpath','//input[@id="para"]')
opt_para$sendKeysToElement(list('29/07/2021'))
opt_para$click()

links_pe <- map(1:62,
             function(x){
               Sys.sleep(3)

               apac_link <- 'https://www.apac.pe.gov.br/component/buscavancada/index.php?option=com_buscavancada&de=01/01/2010&para=29/07/2021&catid=101&busca=&c111bcde8e419562f6a53c4ed872bd89=1&page='

               remDr$navigate(paste0(apac_link,x))

               links <- remDr$getPageSource()[[1]] %>%
                 read_html() %>%
                 xml_find_all('//div[@class="eight columns"]//a') %>%
                 xml_attr('href')


               return(links)

             })


links_pe %>%
  flatten_chr() %>%
  str_c('https://www.apac.pe.gov.br',.) %>%
  tibble(link=.) %>%
  write_excel_csv2('tfwbt/inst/extdata/links_apac_pe.csv')


links_apac_pe <-
read_csv2(file = 'inst/extdata/links_apac_pe.csv')

maybe_get_data_pe <- possibly(get_data_pe,tibble())

reservatorios_pe_1 <- map_dfr(links_apac_pe$link,
                              get_data_pe)

reservatorios_pe <- reservatorios_pe_1 %>%
  distinct(reservatorio,data,.keep_all = TRUE) %>%
  select(-pag,-c(abertura:variacao_do_volume_10_3_m_3))

get_data_pe(links_apac_pe$link[1])

links_reservatorios_pe <-
  geral_pe %>%
  xml2::xml_find_all('//div/table//a[contains(@href,"Reservatorios")]') %>%
  xml2::xml_attr('href') %>%
  str_c('https://www.apac.pe.gov.br',.) %>%
  map_dfr(get_data_pe)

reservatorios_pe <- reservatorios_pe %>%
  drop_na(data) %>%
  mutate(data=if_else(year(data)==5020,as_date('2020-09-02'),data)) %>%
  distinct(reservatorio,data,.keep_all = TRUE)

usethis::use_data(reservatorios_pe, overwrite = TRUE)
