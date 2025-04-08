
library(leaflet)
library(leaflet.providers)
library(scales)
library(sf)
library(terra)
library(tidyverse)

focal_hex <- st_read("inputs/focal_hex.shp") %>%
  st_transform(data, crs = "+proj=longlat +datum=WGS84")



# List of types to include
bps_types <- c(
  "Allegheny-Cumberland Dry Oak Forest and Woodland",
  "Central Interior Highlands Calcareous Glade and Barrens",
  "Central Interior and Appalachian Floodplain Systems",
  "Central Interior and Appalachian Riparian Systems",
  "South-Central Interior Mesophytic Forest",
  "Southern Appalachian Oak Forest",
  "Southern Interior Low Plateau Dry-Mesic Oak Forest",
  "Southern and Central Appalachian Cove Forest"
)

evt_types <- c(
  "Allegheny-Cumberland Dry Oak Forest and Woodland",
  "South-Central Interior Mesophytic Forest",
  "Southern Appalachian Oak Forest",
  "Southern Interior Low Plateau Dry-Mesic Oak Forest",
  "South-Central Interior Small Stream and Riparian Forest",
  "Southern Appalachian Low-Elevation Pine Forest"
)

# Filter the data
focal_hex_filtered <- focal_hex %>%
  filter(BPS_NAME %in% bps_types & EVT_NAME %in% evt_types)




plot(focal_hex)


bps_colors <- c(
  "Allegheny-Cumberland Dry Oak Forest and Woodland" = "#DDCC77",
  "Central Interior Highlands Calcareous Glade and Barrens" = "#999933",
  "Central Interior and Appalachian Floodplain Systems" = "#332288",
  "Central Interior and Appalachian Riparian Systems" = "#88CCEE",
  "South-Central Interior Mesophytic Forest" = "#117733",
  "Southern Appalachian Oak Forest" = "#CC6677",
  "Southern Interior Low Plateau Dry-Mesic Oak Forest" = "#CC6677",
  "Southern and Central Appalachian Cove Forest" = "#DDDDDD"
)

evt_colors <- c(
  "Allegheny-Cumberland Dry Oak Forest and Woodland" = "#DDCC77",
  "South-Central Interior Mesophytic Forest" = "#117733",
  "Southern Appalachian Oak Forest" = "#CC6677",
  "Southern Interior Low Plateau Dry-Mesic Oak Forest" = "#CC6677",
  "South-Central Interior Small Stream and Riparian Forest" = "#0072B2",
  "Southern Appalachian Low-Elevation Pine Forest" = "#000000"
)

pal_bps <- colorFactor(
  palette = bps_colors,
  domain = focal_hex_filtered$BPS_NAME
)

pal_evt <- colorFactor(
  palette = evt_colors,
  domain = focal_hex_filtered$EVT_NAME
)


leaflet(focal_hex_filtered) %>%
  addProviderTiles("Stadia.AlidadeSmooth") %>%
  addPolygons(
    fillColor = ~pal_bps(BPS_NAME),
    color = "#BDBDC3",
    weight = 1,
    opacity = 1,
    fillOpacity = 1.0,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#666",
      fillOpacity = 1.0,
      bringToFront = TRUE
    ),
    label = ~BPS_NAME,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    ),
    group = "Biophysical Settings"
  ) %>%
  addPolygons(
    fillColor = ~pal_evt(EVT_NAME),
    color = "#BDBDC3",
    weight = 1,
    opacity = 1,
    fillOpacity = 1.0,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#666",
      fillOpacity = 1.0,
      bringToFront = TRUE
    ),
    label = ~EVT_NAME,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    ),
    group = "Existing Vegetation Types"
  ) %>%
  addLayersControl(
    overlayGroups = c("Biophysical Settings", "Existing Vegetation Types"),
    options = layersControlOptions(collapsed = FALSE)
  ) 
