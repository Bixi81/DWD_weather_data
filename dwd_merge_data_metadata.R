
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Peter Heindl
# April 2020
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Merge weather data and station meta data 

############################################
# Merge station metadata and actuall data
mydfs = c(ls(pattern="wdf_"))
for (d in mydfs){
  temp <- get(d)
  assign(d, merge(temp, stations, by=c("STATIONS_ID"),all.x = T))
}
rm(temp,d,mydfs)

############################################
# Save
savepath = "C:/Users/User/Documents/R/weather/data/"

mydfs = c(ls(pattern="wdf_"))
for (d in mydfs){
  temp <- get(d)
  write.csv(x=temp, file=paste0(savepath,d,".csv"),row.names = FALSE) 
}





