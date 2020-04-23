# pacotes necessários

library(shiny)
library(tidyverse)
theme_set(theme_bw() + theme(text = element_text(size = 6)))
library(plotly)
library(scales)
library(reshape2)

# leitura dos dados

#casos_uf <- read_csv(file="~/srag/casos_uf.csv")
casos_uf  <- read_csv(file="casos_uf.csv")
casos_uf <- filter(casos_uf, ano >= 2011)
populacao <- read_csv(file="populacao.csv")

# nomes das UFs

uf <- unique(casos_uf$territory_name)

# ano mais recente

max_ano  <- max(casos_uf$ano)

# semana mais recente

max_week <- casos_uf %>%
	filter(ano == max_ano) %>%
	summarise(max(epiweek)) %>%
	as.numeric()

casos_uf <- casos_uf %>%
	filter(epiweek <= max_week)

# adicionar epiweek a populacao

populacao <- populacao[rep(seq_len(nrow(populacao)), each = max_week), ]
populacao$epiweek <- rep(rep(1:max_week, length(uf)),length(2011:max_ano) )

# calculo da incidencia

casos_uf <- left_join(casos_uf, populacao) %>%
	mutate(incidence = 100000*casos/populacao)

# remocao de colunas desnecessarias

casos_uf <- casos_uf %>% 
	select(ano, epiweek, casos, incidence, territory_name)

# processamento dos dados

srag_filtrado <- casos_uf %>%
	filter(epiweek <= max_week)

