function(input, output, session) {
  
  # dados selecionados por UF
  
  selectedDataUF <- reactive({
    srag_filtrado %>%
      filter(territory_name == input$uf) %>%
      filter(ano >= input$slider[1]) %>%
      filter(ano <= input$slider[2]) %>%
      mutate(ano = factor(ano))
  })
  
  # graficos para cada UF
  
  output$plot1 <- renderPlot({
    if(input$media == TRUE) {
      selectedDataUF() %>%
        filter(ano != input$slider[2]) %>%
        group_by(epiweek) %>%
        summarise(media = mean(casos)) %>%
        full_join(filter(selectedDataUF(), ano == input$slider[2])) %>%
        select(epiweek, media, casos) %>%
        melt(id.var = "epiweek") %>%
        mutate(variable = ifelse(variable == "media", "Média dos\nanos anteriores", input$slider[2])) %>%
        ggplot(., aes(x = epiweek, y = value, group = variable, colour = variable)) +
      geom_line() +
      scale_colour_viridis_d(direction = 1) +
      scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
      labs(x = "Semana", y = "Número de Casos", colour = "Ano", 
           title = paste0(selectedDataUF()$territory_name, ": Número de Casos de SRAG")) +
      theme(legend.position="top")} else {
        ggplot(selectedDataUF(), aes(x = epiweek, y = casos, group = ano, colour = ano)) +
          geom_line() +
          scale_colour_viridis_d(direction = -1) +
          scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
          labs(x = "Semana", y = "Número de Casos", colour = "Ano", 
               title = paste0(selectedDataUF()$territory_name, ": Número de Casos de SRAG")) +
          theme(legend.position="top")
      }
  })
  
  # graficos para cada UF - incidencia
  
  output$plot4 <- renderPlot({
    ggplot(selectedDataUF(), aes(x = epiweek, y = incidence, group = ano, colour = ano)) +
      geom_line() +
      scale_colour_viridis_d(direction = -1) +
      scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
      labs(x = "Semana", y = "Casos por 100.000 Habitantes", colour = "Ano", 
           title = paste0(selectedDataUF()$territory_name, ": Incidência de Casos de SRAG")) +
      theme(legend.position="top")
  })
  
  # dados selecionados para todas as UFs
  
  selectedData <- reactive({
    srag_filtrado %>%
      filter(ano >= input$slider[1]) %>%
      filter(ano <= input$slider[2]) %>%
      mutate(ano = factor(ano))
  })
  
  # graficos para todas as UFs
  
  output$plot2 <- renderPlot(height = 2000, {
    
    ggplot(selectedData(), aes(x = epiweek, y = incidence, group = ano, colour = ano)) +
      geom_line() +
      scale_colour_viridis_d(direction = -1) +
      scale_x_continuous(breaks = pretty_breaks(5), minor_breaks = NULL) +
      labs(x = "Semana", y = "Casos por 100.000 Habitantes", colour = "Ano", 
           title = "Incidência de Casos de SRAG por Estado") +
      facet_wrap(~ territory_name, scales = "free", ncol = 2) +
      theme(legend.position = "top")
  })
  
  
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
  
  output$plot3 <- renderPlot({
    if(input$media == TRUE) {
      selectedDataBrasil() %>%
        filter(ano != input$slider[2]) %>%
        group_by(epiweek) %>%
        summarise(media = mean(casos)) %>%
        full_join(filter(selectedDataBrasil(), ano == input$slider[2])) %>%
        select(epiweek, media, casos) %>%
        melt(id.var = "epiweek") %>%
        mutate(variable = ifelse(variable == "media", "Média dos\nanos anteriores", input$slider[2])) %>%
        ggplot(., aes(x = epiweek, y = value, group = variable, colour = variable)) +
        geom_line() +
        scale_colour_viridis_d(direction = 1) +
        scale_x_continuous(breaks = pretty_breaks(10),  minor_breaks = NULL) +
        labs(x = "Semana", y = "Número de Casos", colour = "Ano", 
             title = "Brasil: Número de Casos de SRAG") +
        theme(legend.position="top")} else {
          ggplot(selectedDataBrasil(), aes(x = epiweek, y = casos, group = ano, colour = ano)) +
            geom_line() +
            scale_colour_viridis_d(direction = -1) +
            scale_x_continuous(breaks = pretty_breaks(10), minor_breaks = NULL) +
            labs(x = "Semana", y = "Número de Casos", colour = "Ano", 
                 title = "Brasil: Número de Casos de SRAG") +
            theme(legend.position = "top")
        }
  })
}

