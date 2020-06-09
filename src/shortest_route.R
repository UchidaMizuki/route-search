library(tidyverse)
library(sf)

# shortest route ----------------------------------------------------------

res <- read_sf("dat/sample.gpkg")

res %>% 
  ggplot() +
  geom_sf()

.sf <- read_sf("dat/sample.gpkg") %>% 
  st_set_crs(4326) %>% # WGS 84
  select(highway, oneway) %>% 
  filter(highway %in% c("motorway",
                        "trunk",
                        "primary",
                        "secondary",
                        "tertiary",
                        "unclassified",
                        "residential",
                        "motorway_link",
                        "trunk_link",
                        "primary_link",
                        "secondary_link",
                        "tertiary_link")) %>% 
  select(-highway)

sf_oneway_yes <- .sf %>% 
  filter(oneway %in% c("yes", "true", "1")) %>% 
  select(-oneway)

.sf_oneway_no <- .sf %>% 
  filter(oneway %in% c("no", "false", "0", "")) %>% 
  select(-oneway)
.sf_oneway_no_reverse <- .sf_oneway_no %>% 
  st_reverse()
sf_oneway_no <- .sf_oneway_no %>% 
  # なぜrbind?
  rbind(.sf_oneway_no_reverse)

sf_oneway_reverse <- .sf %>% 
  filter(oneway %in% c("-1", "reverse")) %>% 
  select(-oneway) %>% 
  st_reverse()

sf <- sf_oneway_yes %>% 
  rbind(sf_oneway_no, sf_oneway_reverse)
