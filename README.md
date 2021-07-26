
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Trabalho Final de Web Scraping do Théo (tfwbt)

<!-- badges: start -->

[![R-CMD-check](https://github.com/theoadepaula/tfwbt/workflows/R-CMD-check/badge.svg)](https://github.com/theoadepaula/tfwbt/actions)
<!-- badges: end -->

O objetivo do pacote tfwbt é para utilizar os conhecimentos aprendidos
no curso de web scraping do [Curso R](https://curso-r.com/) e aplicar na
obtenção dos dados dos reservatórios hídricos fornecidos pelas
secretarias estaduais de meio ambiente ou relacionados ao meio ambiente.

A motivação dessa aplicação é para pegar os dados de forma rápida para
alimentação do sistema utilizado no meu trabalho, que verifica o nível
dos reservatórios das bacias hidrográficas e/ou dos estados. Para o
recorte do trabalho, serão obtidos dados dos alguns dos estados do
Nordeste, que não estão sob os cuidados do
[DNOCS](https://www.gov.br/dnocs/pt-br) ou da
[ANA](https://www.gov.br/ana/pt-br), além de um reservatório que fica em
Minas Gerais, que faz parte da Bacia do São Francisco.

## Instalação do pacote

O pacote pode ser instalado pelo [GitHub](https://github.com/) pelos
comandos abaixo:

``` r
# install.packages("devtools")
devtools::install_github("theoadepaula/tfwbt")
```

## Funções do pacote

Para um maior detalhamento, são esses os estados que terão os dados
captados:

-   Bahia
-   Ceará
-   Minas Gerais
-   Paraíba
-   Pernambuco
-   Rio Grande do Norte
-   Sergipe

### Bahia

A função para pegar os dados do estado do Bahia é o get\_data\_ba(), que
necessita de link que fica no site do
[INEMA](http://www.inema.ba.gov.br), na parte de [informativo semanal de
monitoramento de
barragens](http://www.inema.ba.gov.br/gestao-2/barragensreservatorios/informativo-semanal-de-monitoramento-das-barragens/).

A tabela gerada pela função é extraída do link informado, que é um PDF.
O passo a passo pode ser visto dentro do link da função get\_data\_ba().

``` r
library(tfwbt)
library(DT)
## basic example code

get_data_ba('http://www.inema.ba.gov.br/wp-content/uploads/2021/07/INFORMATIVO-SEMANAL-N%C2%BA-29-2021.pdf') %>% 
  DT::datatable()
```

<img src="man/figures/README-bahia-1.png" width="100%" />

### Ceará

A função para pegar os dados do estado do Ceará é o get\_data\_ce(), que
utiliza o link que fica no site da [FUNCEME](http://www.funceme.br/), na
parte do [Portal Hidrológico](http://www.hidro.ce.gov.br/).

A tabela gerada pela função é extraída do XML fornecido pela página. Ela
possui uma API escondida, que requer como query um epoch, marcador de
tempo em números inteiros. O passo a passo pode ser visto dentro do link
da função get\_data\_ce().

``` r
library(tfwbt)
## basic example code

get_data_ce()%>% 
  DT::datatable()
```

<img src="man/figures/README-ceara-1.png" width="100%" />

### Minas Gerais

A função para pegar os dados da barragem Bico de Pedra, que fica no
estado de Minas Gerais, é o get\_data\_mg(), que precisa do link que
fica no site do [Distrito de Irrigação do Perímetro
Gorutuba](http://www.dig.org.br/home).

A tabela gerada pela função é extraída pela tabela html fornecida pela
página. O passo a passo pode ser visto dentro do link da função
get\_data\_mg().

``` r
library(tfwbt)
## basic example code

get_data_mg('http://www.dig.org.br/noticia/Junho-2020-distrito-do-gorutuba/251/')%>% 
  DT::datatable()
```

<img src="man/figures/README-minas_gerais-1.png" width="100%" />

### Paraíba

A função para pegar os dados do estado do Paraíba é o get\_data\_pb(),
que utiliza internamente o link que fica no site da
[AESA](http://www.aesa.pb.gov.br/).

A tabela gerada pela função é extraída do JSON fornecido pela página.
Ela possui uma API escondida, que requer como query um epoch, marcador
de tempo em números inteiros, como o estado do Ceará. O passo a passo
pode ser visto dentro do link da função get\_data\_pb().

``` r
library(tfwbt)
## basic example code

get_data_pb()%>% 
  DT::datatable()
```

<img src="man/figures/README-paraiba-1.png" width="100%" />

### Pernambuco

A função para pegar os dados do estado de Pernambuco é o
get\_data\_pe(), que usa o link que fica no site da
[APAC](https://www.apac.pe.gov.br/), na parte de [monitoramento de
boletins de reservatórios
hidrológicos](https://www.apac.pe.gov.br/rios-e-reservatorios).

A tabela gerada pela função é extraída do PDF, que vem do link
fornecido. O passo a passo pode ser visto dentro do link da função
get\_data\_pe().

``` r
library(tfwbt)
## basic example code

get_data_pe('https://www.apac.pe.gov.br/uploads/Boletim-Monitoramento-Reservatorios26-07-2021.pdf')%>% 
  DT::datatable()
```

<img src="man/figures/README-pernambuco-1.png" width="100%" />

### Rio Grande do Norte

A função para pegar os dados do estado de Rio Grande do Norte é o
get\_data\_rn(), que usa o link que fica no site da
[SEARN](http://www.searh.rn.gov.br/), na parte de [Situação Volumétrica
de Reservatórios do
RN](http://sistemas.searh.rn.gov.br/MonitoramentoVolumetrico/).

A tabela gerada pela função é extraída pela tabela html fornecida pela
página, como no caso da barragem Bico da Pedra - MG. O passo a passo
pode ser visto dentro do link da função get\_data\_rn().

``` r
library(tfwbt)
## basic example code

get_data_rn()%>% 
  DT::datatable()
```

<img src="man/figures/README-rio_grande_do_norte-1.png" width="100%" />

### Sergipe

A função para pegar os dados do estado de Rio Grande do Norte é o
get\_data\_se(), que usa o link que fica no site da
[SEDURBS](https://sedurbs.se.gov.br/), na parte do [Portal de Recursos
Hídricos](https://sedurbs.se.gov.br/portalrecursoshidricos/).

A tabela gerada pela função é extraída do PDF, que vem do link
fornecido, como os estados da Bahia e Pernambuco. O passo a passo pode
ser visto dentro do link da função get\_data\_se().

``` r
library(tfwbt)
## basic example code

get_data_se('https://sedurbs.se.gov.br/portalrecursoshidricos/gerenciamento/boletins_reservatorio/Boletim%2027-%2005_07_2021.pdf')%>% 
  DT::datatable()
```

<img src="man/figures/README-sergipe-1.png" width="100%" />
