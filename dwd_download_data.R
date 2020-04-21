library(readr)
library(dplyr)
library(rvest)
library(XML)
library(httr)
library(stringr)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Peter Heindl
# April 2020
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Download (open) weather data from Deutscher Wetterdienst (DWD) 
# Weather stations: https://www.dwd.de/DE/leistungen/klimadatendeutschland/messnetzkarten.html?lsbId=343278
# Type of data is specified in "mytypes" below

# Download files from URLs like:
# https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/air_temperature/recent/stundenwerte_TU_00071_akt.zip

# Downloads "recent" data from https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/
# Data are ZIP files, these ZIP files will be unzipped in "mypath" (a temporary folder)
# Data from temporary are stored in a list of DFs
# The list of DFs is finally aggregated to one (long) DF containing the data for a certain type of measure, e.g. "air_temperature"

# Data can be merged with measuring station metadata 
# Use file "dwd_stations_metadata.R" to load metadata from: https://www.dwd.de/DE/leistungen/klimadatendeutschland/statliste/statlex_html.html?view=nasPublication&nn=16102
# Use file "dwd_merge_data_metadata.R" to merge metadata and downloaded data and to save data locally
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##############################################
# Download options
options(timeout=36000) 
# Create temp dir
mypath = "D:/dwd_temp"
dir.create(mypath, showWarnings = FALSE)

# Types of data
mytypes = c("air_temperature",
            "cloudiness",
            "dew_point",
            "precipitation",
            "pressure",
            "soil_temperature",
            "sun",
            "visibility",
            "wind",
            "wind_synop")


for (t in mytypes){
  # Get info from page
  page <- read_html(paste0("https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/",t,"/recent/"))
  files = page %>% html_nodes("a") %>% html_attr("href")
  # Loop over ZIP files
  for (sid in files){
    if (grepl(".zip",sid, fixed = TRUE)==T){
      # Get type of measure
      posi = gregexpr(pattern ='_',sid)
      mtype = substr(sid,posi[[1]][1]+1,posi[[1]][2]-1)
      starttime = Sys.time()
      tryCatch({
        URL <- paste0("https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/",t,"/recent/",sid)
        download.file(URL, paste0(mypath,sid), quiet = TRUE)
        if (file.exists(paste0(mypath,sid))) 
          unzip(paste0(mypath,sid), exdir = paste0(mypath))
        file.remove(paste0(mypath,sid))
        ## further options
        Sys.sleep(0.2)
        print(paste0("Loading ", sid, " | took: ", (Sys.time() - starttime)))
      }, error = function(e){
        message(paste0("ERROR in ", sid, " | ", (Sys.time() - starttime)))
        print(e)})
    }
  }
  # Remove all metadata
  file.remove(file.path(mypath, dir(path=mypath ,pattern="Meta*")))
  tryCatch({
    # Load to list od DFs
    files <- list.files(path=sprintf("%s",mypath), pattern="produkt*", full.names=TRUE, recursive=FALSE)
    myfiles = lapply(files, function(x) as.data.frame(read.csv(x, sep=";",header=T,na = "-",skip=0,encoding="UTF-8")))
    # Bind list to one df
    assign(paste0("wdf_",mtype,"_",t),dplyr::bind_rows(myfiles,.id = "column_label"))
  }, error = function(e){
    message(paste0("Could not bind DFs"))
  print(e)})
  # Remove all temp files
  do.call(file.remove, list(list.files(mypath, full.names = TRUE)))
}

# Clear workspace
unlink(mypath,recursive = T)
rm(files,sid,starttime,t,URL,myfiles,page,mypath,mytypes)

# Add measurement type key to each DF from DF name for later merging with metadata
mydfs = c(ls(pattern="wdf_"))
for (i in mydfs){
  posi = gregexpr(pattern ='_',i)
  mtype = substr(i,posi[[1]][1]+1,posi[[1]][2]-1)
  mtype=ifelse(mtype=="F", "FF", mtype)
  print(mtype)
  temp <- get(i)
  temp$mtype = mtype
  assign(i, temp)
}

rm(i,mtype,mydfs,temp,posi)


  