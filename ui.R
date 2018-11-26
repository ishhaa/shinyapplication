#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(maptools)
library(maps)
library(plotly)
library(shinydashboard)
library(shinythemes)
library(DT)
library(leaflet)
library(shinyjs)
library(V8)
library(reshape)


dashboardPage(skin = "blue",
              dashboardHeader(title = "Monitoring of CO2 emissions from passenger cars",
                              tags$li(class = "dropdown",
                                      tags$a(href = "", 
                                             target = "_blank", 
                                             tags$img(height = "20px", 
                                                      src = "facebook.png")
                                      )
                              ),
                              
                              tags$li(class = "dropdown",
                                      tags$a(href = "", 
                                             target = "_blank", 
                                             tags$img(height = "20px", 
                                                      src = "twitter.png")
                                      )
                              ),
                              
                              tags$li(class = "dropdown",
                                      tags$a(href = "", 
                                             target = "_blank", 
                                             tags$img(height = "20px", 
                                                      src = "linkedin.png")
                                      )
                              )
                              
                              
              ),
              
              
              dashboardSidebar(
                
                sidebarMenu(id = "sbm",
                            menuItem("Tableau de bord", tabName = "dashboard", icon = icon("dashboard")),
                            menuItem("Repartition globale", tabName = "repart", icon = icon("area-chart")),
                            menuItem("Repartition par pays", tabName = "repartpays", icon = icon("area-chart"))
                )
                
                
                
              ),
              
              
              dashboardBody(
                
                useShinyjs(), 
                extendShinyjs(text = "shinyjs.activateTab = function(name){
                              setTimeout(function(){
                              $('a[href$=' + '\"#shiny-tab-' + name + '\"' + ']').closest('li').addClass('active')
                              }, 200);
                              }"
                ),
                
                tabItems(
                  
                  tabItem(tabName = "dashboard"),
                  
                  tabItem(tabName = "repart",
                          fluidPage(
                            title = "Data Overview",
                            fluidRow(
                              column(width = 12,
                                     valueBoxOutput("totreg", width = 4),
                                     valueBoxOutput("totcountries", width = 4),
                                     valueBoxOutput("moyCO2", width = 4)
                                     
                              )
                            ),
                            
                            plotlyOutput("plot1",height='auto', width = 'auto'))
                          
                  ),
                  
                  tabItem(tabName = "repartpays",
                          
                          fluidPage(
                            title = "Emission CO2 par pays",
                            column(width = 3,
                                   box(
                                     title = "Query Builder",
                                     status = "primary",
                                     width = 12,
                                     solidHeader = TRUE,
                                     background = "light-blue",
                                     box(
                                       status = "primary",
                                       solidHeader = FALSE,
                                       width = 12,
                                       background = "navy",
                                       uiOutput("countrylist")
                                     ),
                                     box(
                                       status = "primary",
                                       solidHeader = FALSE,
                                       width = 12,
                                       background = "navy",
                                       sliderInput("hviQuery", label = "Year Range", min = 2011, max = 2015, value = c(2011,2015))
                                     ),
                                     actionButton("query", label = "OK")
                                     
                                   )
                            ),
                            
                            ,
                            conditionalPanel(
                              condition = "input.query",
                              column(width = 10,
                                     box(
                                       title = textOutput("Design"), 
                                       status = "primary",
                                       width = 12,
                                       height = 1500,
                                       solidHeader = TRUE,
                                       collapsible = TRUE,
                                       fluidRow(
                                         box(
                                           status = "primary",
                                           width = 12,
                                           solidHeader = FALSE,
                                           collapsible = TRUE,
                                           valueBoxOutput("totcity_country", width = 3),
                                           valueBoxOutput("totAttacks_country", width = 3),
                                           valueBoxOutput("totlife_country", width = 3),
                                           valueBoxOutput("totloss_country", width = 3)
                                         )# end of box
                                       ), #end of fluid row
                                       fluidRow(
                                         column(width = 12,
                                                box(
                                                  title = "Attacks",
                                                  status = "primary",
                                                  width = 4,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  plotlyOutput("plot7",height = 250)
                                                ),
                                                box(
                                                  title = "Targets",
                                                  status = "primary",
                                                  width = 4,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  plotlyOutput("plot8",height = 250)
                                                ),
                                                box(
                                                  title = "Weapons",
                                                  status = "primary",
                                                  width = 4,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  plotlyOutput("plot9",height = 250)
                                                )
                                                
                                         )
                                       ), # end of fluid row
                                       fluidRow(
                                         column(width = 12,
                                                
                                                box(
                                                  title = "Major Attacks (Click on points for more information)",
                                                  status = "primary",
                                                  width = 6,
                                                  height = 475,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  style = "color: #444",
                                                  leafletOutput("country_map")
                                                ),
                                                box(
                                                  title = "Major Terrorist Groups",
                                                  status = "primary",
                                                  width = 6,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  style = "color: #444",
                                                  DT::dataTableOutput("groupnameTbl")
                                                )
                                         )
                                         
                                       ),
                                       fluidRow(
                                         column(width = 12,
                                                box(
                                                  title = textOutput("tseries"),
                                                  status = "primary",
                                                  width = 12,
                                                  solidHeader = FALSE,
                                                  collapsible = TRUE,
                                                  plotlyOutput("plot10",height = 350)
                                                  
                                                )
                                                
                                         )
                                       )
                                     )
                              )
                            )
                            
                            
                          ) 
                          
                          
                  )
                )
              )
              
)             
