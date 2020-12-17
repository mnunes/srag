# preparacao dos dados

# fonte: https://gitlab.procc.fiocruz.br/mave/repo/blob/master/Dados/InfoGripe/serie_temporal_com_estimativas_recentes.csv

# pacotes necessários

library(tidyverse)

# leitura dos dados

#casos_uf <- read_csv(file="~/srag/casos_uf.csv")
casos_uf  <- read.table(file="serie_temporal_com_estimativas_recentes.txt", sep = ";", dec = ",", header = TRUE)
`%notin%` <- Negate(`%in%`)
casos_uf <- casos_uf %>%
	filter(escala == "casos") %>%
	filter(dado == "srag") %>%
	mutate(ano = Ano.epidemiológico, 
				 territory_name = Unidade.da.Federação, 
				 epiweek = Semana.epidemiológica, 
				 casos = Casos.semanais.reportados.até.a.última.atualização) %>%
	filter(ano >= 2011) %>%
	select(ano, epiweek, casos, territory_name) %>%
	filter(territory_name %notin% c("Regional Centro", "Regional Leste", "Regional Norte", "Regional Sul", "Região Centro-oeste", "Região Norte", "Região Nordeste", "Região Sul", "Região Sudeste", "Brasil")) %>%
	mutate(casos = round(casos, digits = 0))

write_csv(casos_uf, file = "casos_uf.csv")

