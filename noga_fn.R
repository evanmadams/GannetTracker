#query the ebird api to get recent information on gannets relative to a location

#file.edit("~/.Renviron")
#api key: EBIRD_KEY = k6tso6e9ft5p

ebird_comp <- function(days){
  
require(rebird)
require(tidyverse)
require(leaflet)
require(sf)
require(htmltools)

states <- c('US-NY', 'US-NJ', 'US-CN', 'US-RI', 'US-MA')

obs <- list()
for(i in 1:length(states)){
obs[[i]] <- ebirdregion(loc = states[i], species = species_code('Morus bassanus'), 
                        back = days,
                        provisional = TRUE,
                        key = 'k6tso6e9ft5p')
}

obs.all <- bind_rows(obs)
obs.all$ebirdlink <- paste0('<a href="https://ebird.org/checklist/', obs.all$subId,'">eBird Link</a')

out <- obs.all
return(out)

}
