rm(list = ls())
getwd()
setwd("RLadies")
df <- read.csv("dublinbikes.csv")

str(df)
names(df)

#> names(df)
#[1] "Name"             "Number"           "Banking"          "Status"          
#[5] "Bike.Stands"      "Available.Stands" "Available.Bikes"  "Last.Updated"    
#[9] "Latitude"         "Longitude"        "Request.Time" 

head(df)
tail(df)

attach(df)
length(Status[Status == 'OPEN'])
length(Status[Status == 'CLOSED'])

sum(is.na(df))

table(Number)


head(Request.Time)
head(Last.Updated)
class(Last.Updated)

#install.packages("anytime")
#library(anytime)

as.numeric(Sys.time())
as.POSIXct(as.numeric(Sys.time()), origin="1970-01-01")

head(Last.Updated)
df$dateupdated <- as.POSIXct((Last.Updated - 60*60)/1000, origin="1970-01-01")
head(df$dateupdated)
class(df$dateupdated)

x <- as.numeric(Sys.time())
as.POSIXct(x - 60*60, origin="1970-01-01")

df$day <- weekdays(as.Date(df$dateupdated))
str(df)

install.packages("data.table")
library(data.table)

DT <- data.table(df)
DT

stands <- DT[, .(numberofstands = unique(Bike.Stands)), by = c("Name", "Number", "Longitude", "Latitude")]
stands
stands[order(-numberofstands)]
#stands[order(Number)]
#stands[order(Name)]

install.packages("ggplot2")
library(ggplot2)
install.packages("ggmap")
library(ggmap)

ggmap::geocode("dublin")

max(Longitude)
min(Longitude)
max(Latitude)
min(Latitude)

lon <- c(-6.24,-6.30)
lat <- c(53.34, 53.36)

Dubcoord <- as.data.frame(cbind(lon,lat))

DubMap <- ggmap::get_map(location = c(lon = mean(Dubcoord$lon), lat = mean(Dubcoord$lat)),
                  zoom = 13,
                  maptype = "terrain",
                  scale = 4)
