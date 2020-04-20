# pacotes necessários

library(shiny)
library(tidyverse)
theme_set(theme_bw() + theme(text = element_text(size = 16)))
library(scales)

# leitura dos dados

#casos_uf <- read.csv(file="~/srag/casos_uf.csv")
casos_uf  <- read.csv(file="casos_uf.csv")
populacao <- read.csv(file="populacao.csv")

# calculo da incidencia

casos_uf <- left_join(casos_uf, populacao) %>%
	mutate(incidence = 100000*casos/population)

# remocao de colunas desnecessarias

casos_uf <- casos_uf %>% 
	select(ano, epiweek, casos, incidence, territory_name)

# nomes das UFs

uf <- unique(casos_uf$territory_name)

# ano mais recente

max_ano  <- max(casos_uf$ano)

# semana mais recente

max_week <- casos_uf %>%
	filter(ano == max_ano) %>%
	summarise(max(epiweek)) %>%
	as.numeric()

# processamento dos dados

srag_filtrado <- casos_uf %>%
	filter(epiweek <= max_week)


