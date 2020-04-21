# o arquivo populacao_bk.csv foi obtido a partir da tabela 6579 do sidra: 
# https://sidra.ibge.gov.br/tabela/6579#resultado

library(tidyverse)
library(reshape2)

populacao <- read_csv(file = "populacao_bk.csv")

# repetir as observacoes de 2019 para 2020 e 
# colocar populacao em formato longo

populacao <- populacao %>%
  mutate(`2020` = `2019`) %>%
  melt()

# renomear as colunas

names(populacao) <- c("territory_name", "ano", "populacao")

# organizar o arquivo final

populacao <- populacao %>%
	arrange(ano, territory_name)

# exportar o arquivo final

write_csv(populacao, "populacao.csv")

