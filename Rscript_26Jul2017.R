df <- read.csv("dublinbikes.csv")

str(df)
names(df)

#> names(df)
#[1] "Name"             "Number"           "Banking"          "Status"          
#[5] "Bike.Stands"      "Available.Stands" "Available.Bikes"  "Last.Updated"    
#[9] "Latitude"         "Longitude"        "Request.Time" 

bikes <- df[ , c(1,2,4,5,6,7,8,9,10)]

head(bikes)
tail(bikes)
sum(is.na(bikes))

attach(bikes)

head(Last.Updated)
class(Last.Updated)

## test POSIXct function
# as.numeric(Sys.time())
# as.POSIXct(as.numeric(Sys.time()), origin="1970-01-01")

head(Last.Updated)
bikes$dateupdated <- as.POSIXct(Last.Updated/1000, origin="1970-01-01")
bikes$date <- as.Date(strptime(bikes$dateupdated, "%Y-%m-%d"))

bikes$day <- weekdays(as.Date(bikes$dateupdated))

install.packages("data.table")
require(data.table)

DT <- data.table(bikes)
DT[,Last.Updated:=NULL]
DT

stands <- DT[, .(numberofstands = unique(Bike.Stands)), by = c("Name", "Number", "Longitude", "Latitude")]
stands
stands[order(-numberofstands)]

## let's see if there were any closed stations
length(Status[Status == 'OPEN']) ## majority open
length(Status[Status == 'CLOSED'])
unique(bikes[Status == 'CLOSED', c("Name", "date")])

## let's find the busiest station
busy <- Available.Stands / Bike.Stands
var1 <- aggregate(busy ~ Number + Name, data = df, FUN = var)
var2 <- var1[order(-var1$busy), ]
var2

## there are multiple entries for the same station at the same time
setkey(DT, Number, dateupdated, Available.Stands, Bike.Stands)
setkey(DT, NULL)
dt2 <- unique(DT)
dt2

# let's compare var with the one above
busy2 <- dt2$Available.Stands / dt2$Bike.Stands
var3 <- aggregate(busy2 ~ Number + Name, data = dt2, FUN = var)
var4 <- var3[order(-var3$busy2), ]
var4
