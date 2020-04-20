# funcao para baixar dados sobre as populações dos estados brasileiros

library(rvest)
library(tidyverse)
library(stringi)

# url de interesse

url <- "https://pt.wikipedia.org/wiki/Lista_de_unidades_federativas_do_Brasil_por_popula%C3%A7%C3%A3o"

# baixar os dados localmente e extrair as tabelas da pagina

pagina <- url %>%
  read_html()

pagina <- pagina %>%
  html_table(fill = TRUE)

populacao <- pagina[[1]]

populacao <- populacao %>%
  select(`Unidade federativa`, `População`)

# fazer os nomes das colunas iguais aos de `infogripe_scrap.R`

names(populacao) <- c("territory_name", "population")

# converter populacao para numerico

populacao <- populacao %>%
  mutate(population = stri_replace_all_charclass(population, "\\p{WHITE_SPACE}", "")) %>%
  mutate(population = as.numeric(population))

# exportar arquivo csv

write_csv(populacao, "populacao.csv")

