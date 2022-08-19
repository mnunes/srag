function(input, output, session) {
  
  # dados selecionados por UF
  
  selectedDataUF <- reactive({
    srag_filtrado %>%
      filter(territory_name == input$uf) %>%
      filter(ano >= input$slider[1]) %>%
      filter(ano <= input$slider[2]) %>%
  		as.data.frame() %>%
      mutate(ano = factor(ano))
  })
  
  # graficos para cada UF
  
  output$plot1 <- renderPlotly({
    if(input$media == TRUE) {
      p <- selectedDataUF() %>%
        filter(ano != input$slider[2]) %>%
        group_by(epiweek) %>%
        summarise(media = mean(casos)) %>%
        full_join(filter(selectedDataUF(), ano == input$slider[2])) %>%
        select(epiweek, media, casos) %>%
        melt(id.var = "epiweek") %>%
        mutate(variable = ifelse(variable == "media", paste("Média\n", input$slider[1], "-", input$slider[2]-1, sep=""), input$slider[2])) %>%
        mutate(Semana = epiweek, Casos = round(value, digits = 0), Grupo = variable) %>%
      ggplot(., aes(x = Semana, y = Casos, group = Grupo, colour = Grupo)) +
      geom_line() +
      scale_colour_viridis_d(direction = 1) +
      scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
      labs(x = "Semana Epidemiológica", y = "Número de Casos", colour = "Ano") +
      theme(legend.position="top")
      p <- ggplotly(p, tooltip = c("Semana", "Casos")) %>%
      	layout(title = list(text = paste0(title = paste0(selectedDataUF()$territory_name, ": Número de Casos de SRAG"))))
      p} else {
        p <- selectedDataUF() %>%
          mutate(Semana = epiweek, Casos = casos) %>%
          ggplot(., aes(x = Semana, y = Casos, group = ano, colour = ano)) +
          geom_line() +
          scale_colour_viridis_d(direction = -1) +
          scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
          labs(x = "Semana Epidemiológica", y = "Número de Casos", colour = "Ano") +
          theme(legend.position="top")
        p <- ggplotly(p, tooltip = c("Semana", "Casos"))  %>%
        	layout(title = list(text = paste0(title = paste0(paste0(selectedDataUF()$territory_name, ": Número de Casos de SRAG")))))
        p
      }
  })
  
  # graficos para cada UF - incidencia
  
  output$plot4 <- renderPlotly({
    p <- selectedDataUF() %>%
      mutate(Semana = epiweek, Incidência = round(incidence, digits = 2)) %>%
      ggplot(., aes(x = Semana, y = Incidência, group = ano, colour = ano)) +
      geom_line() +
      scale_colour_viridis_d(direction = -1) +
      scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
      labs(x = "Semana Epidemiológica", y = "Casos por 100.000 Habitantes", colour = "Ano") +
      theme(legend.position="top")
    p <- ggplotly(p, tooltip = c("Semana", "Incidência")) %>%
    	layout(title = list(text = paste0(title = paste0(paste0(selectedDataUF()$territory_name, ": Incidência de Casos de SRAG")))))
    p
  })
  
  # dados selecionados para todas as UFs
  
  selectedData <- reactive({
    srag_filtrado %>%
      filter(ano >= input$slider[1]) %>%
      filter(ano <= input$slider[2]) %>%
  		as.data.frame() %>%
      mutate(ano = factor(ano))
  })
  
  # graficos para todas as UFs
  
  #output$plot2 <- renderPlotly({
  #  
  #  p <- selectedData() %>%
  #    mutate(Semana = epiweek, Incidência = round(incidence, digits = 2)) %>%
  #    ggplot(., aes(x = Semana, y = Incidência, group = ano, colour = ano)) +
  #    geom_line() +
  #    scale_colour_viridis_d(direction = -1) +
  #    scale_x_continuous(breaks = pretty_breaks(5), minor_breaks = NULL) +
  #    labs(x = "Semana", y = "Casos por 100.000 Habitantes", colour = "Ano", 
  #         title = "Incidência de Casos de SRAG por Estado") +
  #    facet_wrap(~ territory_name, scales = "free", ncol = 2) +
  #    theme(legend.position = "top")
  #  p <- ggplotly(p, tooltip = c("Semana", "Incidência"))
  #  p
  #})
  #
  
  # dados selecionados para o brasil inteiro
  
  selectedDataBrasil <- reactive({
    srag_filtrado %>%
      group_by(ano, epiweek) %>%
      mutate(casos = sum(casos)) %>%
      filter(ano >= input$slider[1]) %>%
      filter(ano <= input$slider[2]) %>%
      as.data.frame() %>%
      mutate(ano = factor(ano))
  })
  
  # graficos para o brasil inteiro
  
  output$plot3 <- renderPlotly({
    if(input$media == TRUE) {
      p <- selectedDataBrasil() %>%
        filter(ano != input$slider[2]) %>%
        group_by(epiweek) %>%
        summarise(media = mean(casos)) %>%
        full_join(filter(selectedDataBrasil(), ano == input$slider[2])) %>%
        select(epiweek, media, casos) %>%
        melt(id.var = "epiweek") %>%
        mutate(variable = ifelse(variable == "media", paste("Média\n", input$slider[1], "-", input$slider[2]-1, sep=""), input$slider[2])) %>%
      	mutate(Semana = epiweek, Casos = round(value, digits = 0)) %>%
        ggplot(., aes(x = Semana, y = Casos, group = variable, colour = variable)) +
        geom_line() +
        scale_colour_viridis_d(direction = 1) +
        scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
        labs(x = "Semana Epidemiológica", y = "Número de Casos", colour = "Ano", 
             title = "Brasil: Número de Casos de SRAG") +
        theme(legend.position="top")
      p <- ggplotly(p, tooltip = c("Semana", "Casos"))
      p} else {
          p <- selectedDataBrasil() %>%
            mutate(Semana = epiweek, Casos = casos) %>%
            ggplot(., aes(x = Semana, y = Casos, group = ano, colour = ano)) +
            geom_line() +
            scale_colour_viridis_d(direction = -1) +
            scale_x_continuous(breaks = pretty_breaks(10), minor_breaks = NULL) +
            labs(x = "Semana Epidemiológica", y = "Número de Casos", colour = "Ano", 
                 title = "Brasil: Número de Casos de SRAG") +
            theme(legend.position = "top")
          p <- ggplotly(p, tooltip = c("Semana", "Casos"))
          p
        }
  })
}

