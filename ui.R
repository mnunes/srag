library(plotly)

pageWithSidebar(
  headerPanel("SRAG ou COVID-19?"),
  sidebarPanel(
    selectInput("uf", "Selecione a UF", uf[order(uf)],
                selected = "Rio Grande do Norte"),
    sliderInput(inputId = "slider", label = "Anos", ticks = FALSE,
                min = 2011, max = max_ano, step = 1, value = c(2016, max_ano)),
    checkboxInput(inputId = "media", label = "Comparar os casos com a média dos anos anteriores? (não serve para incidência)", value = FALSE, width = NULL),
    p("Infelizmente, não há testes de COVID-19 para todos os suspeitos. A", strong("Síndrome Respiratória Aguda Grave (SRAG)"), "possui sintomas muito parecidos com aqueles do COVID-19. Acredito que, com o avanço da pandemia, é importante que a população tenha noção da quantidade de casos da doença que estão por aí."),
    p("Entretanto, temos um bom acesso a casos registrados de SRAG. A Fiocruz tem uma excelente ferramenta de divulgação chamada", a("Info Gripe", href="http://info.gripe.fiocruz.br/", target="_blank"), ", no qual obtive os dados aqui divulgados.",),
    p(strong("ATENÇÃO:"), "alguns gráficos podem dar a entender que está acontecendo um achatamento na curva. É preciso analisar com cuidado, pois um número menor de dados em semanas mais recentes pode significar atraso na notificação.",),
    p("Aplicativo desenvolvido por", a("Marcus Nunes", href="https://marcusnunes.me/", target="_blank"), ". O código está disponível", a("no github", href="https://github.com/mnunes/srag/", target="_blank"), ".")
  ),
  
  mainPanel(
    tabsetPanel(type = "tabs",
                selected = "Casos por UF",
                
                # aba com o grafico de valores absolutos
                tabPanel("Casos por UF",
                         plotlyOutput("plot1", height = 500)
                ),
                
                # aba com o grafico de incidencia
                tabPanel("Incidência por UF",
                         plotlyOutput("plot4", height = 500)
                ),
                
                # aba com os graficos de todos os estados
                #tabPanel("Todas as UFs",
                #         plotlyOutput("plot2", height = 3000)
                #),
                
                # aba com o grafico do brasil
                tabPanel("Casos Brasil",
                         plotlyOutput("plot3", height = 500)
                )
                
    )
)
)

