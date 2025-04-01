#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

require(tidyverse)
require(leaflet)
require(sf)
require(htmltools)
require(rebird)

  ui <- fluidPage(
    titlePanel("WOW NOGA Tracker"),
    
    leafletOutput("map"),
    
    p(),
    
    sliderInput("days", "Days Back:",
                min = 1, max = 10,
                value = 1)
    )
  
  server = function(input, output, session){
    

    
    output$map <- renderLeaflet({
      
        source('noga_fn.R')
        obs.all <- ebird_comp(days = input$days)
        
        leaflet() |> 
        addTiles() |> 
        setView(lng = mean(obs.all$lng), lat = mean(obs.all$lat), zoom = 7) |> 
        addMarkers(data = obs.all,
                   lng = jitter(obs.all$lng, 0.001),
                   lat = jitter(obs.all$lat, 0.001), 
                   popup = ~paste('Species:', comName, '<br>',
                                  'Number:', howMany, '<br>',
                                  'Date:', obsDt, '<br>',
                                   ebirdlink))
    })
    
  }

# Run the application 
shinyApp(ui = ui, server = server)


####

# # Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#     # Application title
#     titlePanel("WOW NOGA Tracker"),
# 
#     # Sidebar with a slider input for number of bins 
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#            plotOutput("distPlot")
#         )
#     )
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
# 
#     output$distPlot <- renderPlot({
#         # generate bins based on input$bins from ui.R
#         x    <- faithful[, 2]
#         bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#         # draw the histogram with the specified number of bins
#         hist(x, breaks = bins, col = 'darkgray', border = 'white',
#              xlab = 'Waiting time to next eruption (in mins)',
#              main = 'Histogram of waiting times')
#     })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)
