library(terra)
library(tidyverse)

# load shapefile
mw4 <- vect("data/mw4.shp")

# create a dataset with just EA_CODE
eas <- mw4[["EA_CODE"]]|> 
  as_tibble()


# let's go through each raster, one at a time

#####################
#    Population     #
#####################
# load raster
raster <- rast("data/mwpop.tif")
# extract to adm4
raster_mw4 <- extract(raster, mw4, fun = sum, na.rm = TRUE) |>
  as_tibble()
# add EA code
raster_mw4$EA_CODE <- mw4$EA_CODE
# remove id
raster_mw4 <- raster_mw4 |> 
  select(-ID)
# add to eas
eas <- eas |> 
  left_join(raster_mw4, by = "EA_CODE")


#####################
#   Night lights    #
#####################
# load raster
raster <- rast("data/ntl.tif")
# extract to adm4
raster_mw4 <- extract(raster, mw4, fun = sum, na.rm = TRUE) |>
  as_tibble()
# add EA code
raster_mw4$EA_CODE <- mw4$EA_CODE
# remove id
raster_mw4 <- raster_mw4 |> 
  select(-ID)
# add to eas
eas <- eas |> 
  left_join(raster_mw4, by = "EA_CODE")


#####################
#    Land class     #
#####################
# load raster
raster <- rast("data/lc.tif")
# rename the layers to remove the -
names(raster) <- gsub("-", "", names(raster))
# extract to adm4
raster_mw4 <- extract(raster, mw4, fun = sum, na.rm = TRUE) |>
  as_tibble()
# add EA code
raster_mw4$EA_CODE <- mw4$EA_CODE
# remove id
raster_mw4 <- raster_mw4 |> 
  select(-ID)
# add to eas
eas <- eas |> 
  left_join(raster_mw4, by = "EA_CODE")


#####################
#       NDVI        #
#####################
# need to do a loop
for (i in 1:12){
  # load raster
  raster <- rast(paste0("data/ndvi", i, ".tif"))
  names(raster) <- paste0("ndvi", i)
  # extract to adm4
  raster_mw4 <- extract(raster, mw4, fun = sum, na.rm = TRUE) |>
    as_tibble()
  # add EA code
  raster_mw4$EA_CODE <- mw4$EA_CODE
  # remove id
  raster_mw4 <- raster_mw4 |> 
    select(-ID)
  # add to eas
  eas <- eas |> 
    left_join(raster_mw4, by = "EA_CODE")
}


#####################
#     Mosaiks       #
#####################
# already at EA level
raster <- read_csv("data/mosaikvars.csv")
eas <- eas |>
  mutate(EA_CODE = as.numeric(EA_CODE)) |>
  left_join(raster, by = "EA_CODE")

# save final dataset
write_csv(eas, "data/geovarseas.csv")








