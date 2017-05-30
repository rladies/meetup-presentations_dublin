# NASA dataset
# https://2017.spaceappschallenge.org/challenges/warning-danger-ahead/when-landslides-strike/details
# https://data.nasa.gov/dataset/Global-Landslide-Catalog-Export/dd9e-wu2v/data

# The most frequent trigger of landslides is intense and prolonged rainfall, 
# which saturates soil on vulnerable slopes. However, the location of extreme precipitation
# isn't always the location of the resulting disaster. Weather forecasting can help predict 
# future landslide events, while studying previous events can provide clues to identify 
# locations that are most vulnerable to experiencing landslide impacts.

# We will do simple exploratory analysis and some plotting (including maps) to help us visualise data

# For spatial visualisations I used syntax and ideas from a very interesting blog called - Notorious BIG (Data)
# http://sarahleejane.github.io/learning/r/2014/09/20/plotting-beautiful-clear-maps-with-r.html
# For more spatial visualisations refer to a very good tutorial, 
# available on: https://data.cdrc.ac.uk/tutorial

# prep the environment ------------------------------------------------

ls()
rm(list = ls())

setwd("RLadies")
getwd()


# get data ----------------------------------------------------------------

glc <- read.csv("GLC.csv")


# get to know your data ------------------------------------------------------------

dim(glc) # rows first
names(glc)
# which variables do you want to focus on? 


# OF INTEREST
# date
# country
# hazard_type
# landslide_type
# landslide_size
# fatalities
# injuries
# latitude
# longitude
# geolocation

str(glc) # gives us class
summary(glc)

attach(glc) # 'version' in a package "base"

head(glc)
tail(glc)
# how is it sorted? NO IDEA


# sorting by date ---------------------------------------------------------

# let's check the class of date
class(date)
names(glc)[2] <- paste("date_factor")
str(date_factor) 
attach(glc) # to attach date_factor
head(date_factor)

date <- as.Date(date_factor, "%d/%m/%Y")
head(date)
summary(date)
glc2 <- cbind(glc, date) # columns binding

sorted <- glc2[order(date),] # sorting, ASC is default; add - for DESC order, but not for factors, only numeric
head(sorted)
tail(sorted)

detach(glc)
attach(sorted)


# plot to visualise your data -------------------------------------------------------

plot_count <- plot(table(format(date, "%Y")), main = "Landslides worldwide", 
     type = "b", ylab = "count", lwd = 1, cex = .6)

plot(date, injuries)
plot(date, fatalities, col = "red")


# explore further ---------------------------------------------------------

table(hazard_type)
# let's disregard this one

table(landslide_size)
landslide_size_lc <- tolower(landslide_size)
table(landslide_size_lc)

table(landslide_type)
landslide_type_lc <- tolower(landslide_type)
table(landslide_type_lc)

barplot(table(landslide_size_lc, landslide_type_lc),
        col = c("lightblue", "mistyrose", "lightcyan",
                "lavender", "cornsilk", "lightgreen"),
        legend = c("", "large", "medium", "small", "unknown", "very large")) 

table(trigger)
trigger_lc <- tolower(trigger)
table(trigger_lc)

# let's see which triggers cause most losses

loss <- injuries + fatalities
loss # NAs?
injuries
fatalities
# injuries - lots of NAs, let's replace them with 0 

injuries[is.na(injuries)] <- 0
injuries

fatalities[is.na(fatalities)] <- 0
fatalities

losses <- injuries + fatalities
losses

plot(losses, trigger_lc) # error??
table(trigger_lc)
which(is.na(trigger_lc))
trigger_lc
sorted2 <- cbind(sorted, trigger_lc, losses)
detach(sorted)
attach(sorted2)

length(which(trigger_lc == ""))

trigger_lc[trigger_lc == ""] <- "unknown"

plot(sorted2$trigger_lc, losses, main = "Landslide triggers",
     ylab = "losses", lwd = 1, cex = .6)

# labels!
plot(sorted2$trigger_lc, losses, main = "Landslide triggers",
     ylab = "losses", lwd = 1, cex = .6, las = 2)

# subset ------------------------------------------------------------------

names(sorted2)
data <- sorted2[,c(1, 4, 7, 8, 10, 11, 32, 33, 34, 35, 36, 37)]

detach(sorted2)
attach(data)
names(data)

class(data)
head(data)
tail(data)
str(data)
summary(data)

# map - github --------------------------------------------------------------------

# https://github.com/rladies

install.packages("ggplot2")
library(ggplot2)

worldmap <- map_data("world")
# other arguments county, france, italy, nz, state, usa, world, world2

p <- ggplot() + coord_fixed() + xlab("") + ylab("")

basemap <- p + geom_polygon(data = worldmap, aes(x=long, y=lat, group=group), 
                                     colour="light grey", fill="light grey")

plot(basemap)
basemap

cleanse <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = 'white', colour = 'white'), 
        axis.line = element_line(colour = "white"), axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(), legend.position="top")

world_map <- basemap + cleanse
world_map

landslides_world <- 
  world_map +
  geom_point(data = data,
             aes(x = data$longitude, y = data$latitude), colour = "Deep Pink",
             fill = "Pink", pch = 21, size = 2)

landslides_world # busy?


# 2015
Y2015 <- subset(data, format(date, "%Y") == 2015)
landslides_2015 <- 
  world_map +
  geom_point(data = Y2015,
             aes(x = Y2015$longitude, y = Y2015$latitude), colour = "Blue",
             fill = "Light Blue", pch = 21, size = 2)

landslides_2015

# sized map ---------------------------------------------------------------

map_data_sized <- 
  world_map +
  geom_point(data = Y2015, 
             aes(x = Y2015$longitude, y = Y2015$latitude, size = Y2015$losses), 
             colour = "Deep Pink", fill = "Pink", pch = 21, alpha = I(0.7)) 

map_data_sized


# coloured map -------------------------------------------------------------

map_data_coloured <- 
  world_map +
  geom_point(data = Y2015, 
             aes(x = Y2015$longitude, y = Y2015$latitude, 
             colour = Y2015$losses), size=2, alpha=I(0.7))

map_data_coloured


# subset for map ----------------------------------------------------------


# NZ
nzsubset <- subset(data, latitude <= -33 & latitude >= -48 & longitude >= 166
                   & longitude <= 178)

nz_map <- map_data("nz")

nz_basemap <- p + geom_polygon(data = nz_map, aes(x=long, y=lat, group=group), 
                               colour="light grey", fill="light grey")

nz_basemap

nz_ls <- 
  nz_basemap +
  geom_point(data = nzsubset, 
             aes(x = nzsubset$longitude, y = nzsubset$latitude), colour = "Deep Pink", 
             fill = "Pink", pch = 21, size = 2, alpha = I(.7))
nz_ls



# practice at home --------------------------------------------------------

nz_sized <- 
  nz_basemap +
  geom_point(data = nzsubset, 
             aes(x = nzsubset$longitude, y = nzsubset$latitude, size = nzsubset$fatalities), 
             colour = "Deep Pink", fill = "Pink", pch = 21, alpha = I(0.7)) 

nz_sized


# USA
usa <- map_data("usa")

usa_basemap <- p + geom_polygon(data = usa, aes(x=long, y=lat, group=group), 
                               colour="light grey", fill="light grey")

usa_basemap

usasubset <- subset(data, latitude <= 50 & latitude >= 24 & longitude <= -65
                   & longitude >= -125)

usa_ls <- 
  usa_basemap +
  geom_point(data = usasubset, 
             aes(x = usasubset$longitude, y = usasubset$latitude), colour = "Deep Pink", 
             fill = "Pink", pch = 21, size = 2, alpha = I(.7))
usa_ls

usa2016 <- subset(usasubset, format(date, "%Y") == 2016)

usals2016 <- usa_basemap +
  geom_point(data = usa2016, 
             aes(x = usa2016$longitude, y = usa2016$latitude), colour = "Dark Green", 
             fill = "Light Green", pch = 21, size = 2, alpha = I(.7))

usals2016
