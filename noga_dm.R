#query the ebird api to get recent information on gannets relative to a location

#file.edit("~/.Renviron")
#api key: EBIRD_KEY = k6tso6e9ft5p

require(rebird)
require(tidyverse)
require(leaflet)
require(sf)
require(htmltools)

states <- c('US-NY', 'US-NJ', 'US-CN', 'US-RI', 'US-MA')


obs <- list()
for(i in 1:length(states)){
obs[[i]] <- ebirdregion(loc = states[i], species = species_code('Morus bassanus'), 
                        back = 1,
                        provisional = TRUE,
                        key = 'k6tso6e9ft5p')
}


obs.all <- bind_rows(obs)
obs.all$ebirdlink <- paste0('<a href="https://ebird.org/checklist/', obs.all$subId,'">eBird Link</a')

leaflet() |> 
  addTiles() |> 
  setView(lng = mean(obs.all$lng), lat = mean(obs.all$lat), zoom = 7) |> 
  addMarkers(data = obs.all, popup = ~paste('Species:', comName, '<br>',
                                            'Number:', howMany, '<br>',
                                            'Date:', obsDt, '<br>',
                                            ebirdlink))


#leaflet example
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
}

# shinyApp(ui, server)