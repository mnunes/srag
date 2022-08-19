# pacotes necessários

library(shiny)
library(tidyverse)
theme_set(
	theme_bw() + 
	theme(text = element_text(size = 10),
				plot.title = element_text(size = 8))
)
library(lubridate)
library(janitor)
library(plotly)
library(scales)
library(reshape2)

# leitura dos dados

casos_uf <- read_csv(file = "casos_uf.csv")

populacao <- read_csv(file = "populacao.csv")

# nomes das UFs

uf <- unique(casos_uf$territory_name)

# ano mais recente

# max_ano  <- max(casos_uf$ano)
max_ano  <- 2020

# semana mais recente

max_week <- casos_uf %>%
	filter(ano ==  max_ano) %>%
	summarise(max(epiweek)) %>%
	as.numeric()

casos_uf <- casos_uf %>%
	filter(epiweek <= max_week)

# adicionar epiweek a populacao

populacao <- populacao[rep(seq_len(nrow(populacao)), each = max_week), ]
populacao <- 
	populacao %>%
	group_by(territory_name, ano) %>%
	mutate(epiweek = 1:n())

# calculo da incidencia

casos_uf <- left_join(casos_uf, populacao) %>%
	mutate(incidence = 100000*casos/populacao)

# remocao de colunas desnecessarias

casos_uf <- casos_uf %>% 
	select(ano, epiweek, casos, incidence, territory_name) %>%
	mutate(casos = round(casos, 0))

# processamento dos dados

srag_filtrado <- casos_uf %>%
	filter(epiweek <= max_week)
	#filter(epiweek <= 50)

#max_week <- srag_filtrado %>%
#	filter(ano ==  max_ano) %>%
#	na.omit() %>%
#	group_by(territory_name) %>%
#	summarise(max_week = max(epiweek))

# srag_filtrado <- left_join(srag_filtrado, max_week)

