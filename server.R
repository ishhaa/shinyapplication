#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RODBC)
library(odbc)
library(shinyGlobe)
library(ggplot2)
library(dplyr)
library(ggmap)
library(maptools)
library(maps)
library(plotly)
library(shinydashboard)
library(DT)
library(leaflet)
library(shinyjs)
library(V8)
library(reshape)
library(sqldf)
library(mapproj)



shinyServer(function(input, output) {
  
  connectionString <- 'Driver={ODBC Driver 13 for SQL Server};Server=tcp:serveurshinyproject.database.windows.net,1433;Database=bdshinyproject;Uid=usershiny@serveurshinyproject;Pwd=Shiny123;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'
  conn <- odbcDriverConnect(connectionString)
  
  #Requete nombre total d'enregistrements
  sqlQuery <- sprintf("select count (*) from [dbo].[Car]")
  dfTotCars <- sqlQuery(conn, sqlQuery)
  dfTotCars
  
  #Requete nombre total de pays
  sqlQuery <- sprintf("select count(distinct(code_country)) from [dbo].[CO2emission]")
  dfTotCountry <- sqlQuery(conn, sqlQuery)
  dfTotCountry   
  
  #Requete moyenne des emissions 
  sqlQuery <- sprintf("select avg(emission) from [dbo].[CO2emission]")
  dfMoyEm <- sqlQuery(conn, sqlQuery)
  dfMoyEm 
  
  #Requete nombre total d'enregistrements par pays
  sqlQuery <- sprintf("select b.[name_country] as pays,
    b.[code_iso3] as code, 
    count(id_car) as totalcars, avg(emission) as emission
    from [dbo].[Co2emission] a, [dbo].[Country] b 
    where  a.[code_country] = b.[code_country] 
    group by b.[name_country], b.[code_iso3]")
  dfTotCarsPays <- sqlQuery(conn, sqlQuery)
  dfTotCarsPays
  
    output$totreg <- renderValueBox({
    countCars <- dfTotCars
    valueBox(countCars,"Enregistrements",icon = icon("car"), color = 'yellow') })
  
  output$totcountries <- renderValueBox({
    countCountries <- dfTotCountry
    valueBox(countCountries,"Pays",icon = icon("globe"), color = 'red') })
  
  output$moyCO2 <- renderValueBox({
    moyEmission <- dfMoyEm
    valueBox(moyEmission,"Moyenne des emissions (g/Km)",icon = icon("flag-o"), color = 'blue') })
  
  
  output$countrylist <- renderUI({
    dfcountries <- dfTotCarsPays$pays
    selectInput("repartpays", label = "Pays:", choices = c(Choose='', as.character(dfcountries)), selected = "Austria", selectize = FALSE)
  })
  
  country_data <- reactive({
    
      c_name = input$repartpays
      minValue = input$hviQuery[1]
      maxValue = input$hviQuery[2]
    
  })
  
  
  output$plot1 <- renderPlotly({
    
    l <- list(color = toRGB("white"), width = 1)
    
    g1 <- list(
      scope = 'europe',
      projection = list(type = 'Mercator'),
      showframe = FALSE,
      showcoastlines = FALSE,
     showcountriesname = TRUE)
    
    
    m <- list(l = 0,r = 0,b = 0,t = 100, pad = 0, autoexpand = TRUE)
    
    p <- plot_geo(dfTotCarsPays,locationmode= "Europe", height = 1000) %>%
      add_trace(
        z = ~emission, color = ~emission, colors = 'Reds',
        text = ~paste(paste("Pays:",pays),paste("Emission:", emission),
                      paste("Total vehicules:", totalcars),sep = "<br />"), 
        locations = ~code,
        marker = list(line = l), hoverinfo = "text"
      ) %>%
      colorbar(title = 'Emission CO2', ticksuffix = 'g/Km',xanchor = "left",thickness = "20",len = 0.5,
               tickfont = list(size = 15), nticks = 5) %>%
      layout(
        title = 'Moyenne des emissions de CO2 en Europe 2011-2015',
        titlefont = list( size=30), 
        geo = g1, xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE), margin = m) %>%
      config(displayModeBar = TRUE)
    
    p  })
  
  
  
  
})
