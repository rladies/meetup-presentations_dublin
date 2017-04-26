## Just an FYI
## R moves up to 5th place in IEEE programming languages ranking
## http://spectrum.ieee.org/computing/software/top-programming-languages-trends-the-rise-of-big-data


## announcements:
  # SLACK - Irish Tech Community
  # F8 Meet-up 18th April at Facebook HQ
  # R-Ladies Global seeking volunteers, apply by 10th April


## tonight: step-by-step, hands-on, let me know if we're going too fast/too slow
## please correct, add


# Prepare your workspace -------------------------------------------------

# Environment window - remove objects
ls()
rm(list = ls())

# Files window - select your working directory here or in the source editor

getwd()

## setwd(<location of your dataset>)

setwd("nameofyourdirectory")

setwd("c:\main_dir\my_folder") ## Windows
setwd("/main_dir/my_folder") ## Mac

setwd("/Users/jo/RLadies")

# Built-in datasets --------------------------------------------------------

# Check out the Packages Window

?datasets
library(help = "datasets")

# We will use "airquality" data
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/airquality.html
# Daily air quality measurements in New York, May to September 1973.

data("airquality")
airquality

# To practice import of various files we will output this dataset with the write.() function, first TXT
# No need to specify the path since we have already set the working dir

write.table(airquality, file = "airquality.txt")

# TXT or TAB delimited files ---------------------------------------------------------------------

mytxt <- read.table("airquality.txt", header = TRUE)
mytxt
class(mytxt)

#!!! DF is data type used for storing tabular data
#!!! special type of a list, because can store different classes of objects (numeric, character, etc.)

# CSV = COMMA SEPARATED VALUES FILE ---------------------------------------------------------------------
?write.csv
write.csv(airquality, file = "airquality.csv", row.names = FALSE)
# if you don't drop row.names an index column
# will be added with a row ID

# you can read in CSV in two ways:

# read.table() function - you need to specify the "sep" argument

mycsvTBL <- read.table("airquality.csv", header = TRUE, sep = ",")
mycsvTBL
class(mycsvTBL)

# read.csv() function

mycsv <- read.csv("airquality.csv", header = TRUE)
mycsv
class(mycsv)

# This file does not need to be stored locally, we could use a link directing us to a website
# DATA.GOV
# https://catalog.data.gov/dataset/population-by-country-1980-2010-d0250/resource/61d6b0d8-1a01-45e6-91ee-2cf4e56e424c

mycsvWEB <- read.csv("http://en.openei.org/doe-opendata/dataset/a7fea769-691d-4536-8ed3-471e993a2445/resource/86c50aa8-e40f-4859-b52e-29bb10166456/download/populationbycountry19802010millions.csv", header = TRUE)
str(mycsvWEB)

# If the ; is separating the values use read.csv2()

## first write.()
# write.table(airquality, file = "airquality2.csv", row.names = FALSE, na = "NA", col.names = TRUE, sep = ";")
write.csv2(airquality, file = "airquality2.csv")

mycsv2 <- read.csv2("airquality2.csv", header = TRUE)
class(mycsv2)


# Delimited Files ---------------------------------------------------

# Separator different than tab, comma or semicolon, e.g. $, /

write.table(airquality, file = "airquality_delim.txt", row.names = FALSE, na = "NA", col.names = TRUE, sep = "$")

mydelim <- read.delim("airquality_delim.txt", sep = "$")
mydelim

# read.delim vs. read.delim2 ===> handle decimals differently . vs , 


# Excel -------------------------------------------------------------------

## We will need to install a couple of packages
# Packages are collections of R functions, data, and compiled code in a well-defined format.
# The directory where packages are stored is called the library.
# R comes with a standard set of packages. Others are available for download and installation.
# Once installed, they have to be loaded into the session to be used.

## package: package XLSX (it'll install Java on your computer)
# Let's chaeck if we have XLSX
any(grepl("xlsx", installed.packages()))

install.packages("xlsx")
library("xlsx")

write.xlsx(airquality, file = "airquality.xlsx")

?read.xlsx
myXLSX <- read.xlsx("airquality.xlsx", sheetIndex = 1)  ## slow for large datasets
myXLSX

## for larger datasets read.xlsx2()
??read.xlsx2

myXLSX2 <- read.xlsx2("airquality.xlsx", sheetIndex = 1, colIndex = NULL) ## quicker, but needs to specify colIndex
myXLSX2
## note how NAs are handled

## arguments startRow, endRow


## package: gdata - XLS only ## needs Perl, Linux and Mac ok, could be tricky on Windows
# you need to specify the path for Perl: perl="C:/Perl/bin/perl.exe"
any(grepl("gdata", installed.packages()))

install.packages("gdata")
library("gdata")

# to write an xls file you need a different package:
install.packages("WriteXLS")
library("WriteXLS")
WriteXLS(airquality, ExcelFileName = "airquality.xls")

# to read an xls:
myXLS <- read.xls("airquality.xls", sheet = 1, header = TRUE)
myXLS

## package: XLConnect - the most popular and potent
any(grepl("XLConnect", installed.packages()))

install.packages("XLConnect")
library("XLConnect")

## You can load entire workbook and later retrieve sheets
wb <- loadWorkbook("airquality.xlsx")
df <- readWorksheet(wb, sheet = 1) 
wb

## Or just load individual sheets
XLSdata <- readWorksheetFromFile("Eurostat_Table.xlsx", sheet = 1)
XLSdata

betterXLSdata <- XLConnect::readWorksheetFromFile("Eurostat_Table.xlsx", sheet = 1, startRow = 3, endRow = 43)
betterXLSdata

## arguments: endRow, endCol


## packages RDOBC & xlsReadWrite is NOT available for R version 3.3.2 (32x bit)
install.packages("xlsReadWrite")

# Take a look at the data ------------------------------------------------

airquality
nrow(airquality)
ncol(airquality)
dim(airquality)


names(airquality)
class(names(airquality)) ## character vector

length(names(airquality))
names(airquality)[2] 
names(airquality)[2] <- paste("Radiation")
?paste

head(airquality) ## first 6 rows
tail(airquality)

summary(airquality)
str(airquality)

missings <- is.na(airquality)
sum(is.na(airquality))
sum(missings)

airquality$Wind

is.na(airquality$Ozone)
sum(is.na(airquality$Ozone))
which(is.na(airquality$Ozone))
airquality[which(is.na(airquality)),]

# SUBSETTING / SLICING

airquality[1,]
airquality[,1]

airquality[,5:6]
airquality[1:20,1:2]

airquality$Ozone

airquality[c("Day", "Month")] # if the order/position of attributes is NOT known

airquality[["D", exact = FALSE]] # if you can't remember the name of the attribute

airquality$Wind # $

airquality[1:10, "Wind"]
airquality[1:10, "Wind", drop = FALSE] # matrix rather than vector

airquality$Temp[airquality$Temp > 90]
hotdays <- airquality$Temp[airquality$Temp > 90]

attach(airquality)

Wind
Ozone
Day[32:61]

airquality[Temp > 90, "Wind"]

table(Month)
summary(Ozone)
mean(Temp)
airquality$TempC <- (Temp-32)*0.5556

airquality$Variable <- Ozone*2
airquality$Variable

airquality$TempC <- round(((Temp-32)*0.5556),1) ## roundup
airquality$TempC

mean(TempC) # not attached, because it's new
min(TempC)
max(TempC)

Temp_May<- airquality[1:31, c("TempC", "Ozone")]
Ozone_May <- airquality[1:31, "Ozone"]
mean(Temp_May)

MayData <- subset(airquality, Month == 5)
str(MayData)
      ##OR
MayData <- airquality[airquality$Month == 5,]
str(MayData)

# add an extra attribute

Year <- rep(1973, each = 153) 
Year

df <- cbind(airquality, Year)

df
airquality$Date <- as.Date(with(df, paste(Year, Month, Day, sep="-")), "%Y-%m-%d")
## ISO 8601 

airquality$Date

head(airquality)

## NAs

str(airquality)
mean(Radiation)
is.na(Radiation)

mean(Radiation, na.rm = TRUE)

# Removing NAs

x <- na.omit(airquality) ## every row containing NA across all columns
dim(x)

is.na(x$Radiation)
mean(x$Radiation)

x <- na.omit(airquality$Radiation)
mean(x)

Ozone
is.na(Ozone)
missings <- is.na(Ozone)
Ozone[!missings]

## complete cases
airquality[1:8,]
nonNA <- complete.cases(airquality)
airquality[nonNA,][1:8,]

### you can change values to NAs

Wind
Wind[1:5] <- NA
Wind
mean(Wind)

table(Ozone)
table(Ozone, useNA = "ifany")

sort(Ozone)
sort(Ozone, na.last = TRUE)

## NA actions

Wind
na.omit(Wind)
na.exclude(Wind) # same but different for some modeling functions 
na.fail(Ozone)
na.pass(Ozone)

df <- subset(airquality, select = -c(Day))
df

# JSON Files --------------------------------------------------------------


# package: rjson
# syntax: JsonData <- fromJSON(file = "<filename.json>")
#         or
#         JsonData <- fromJSON(file = "<URL to your JSON file>")


# XML Files ---------------------------------------------------------------


# package: xml
# syntax: url <- "<a URL with XML data>"
#         data_df <- xmlToDataFrame(url)


# Statistical Packages ----------------------------------------------------

## SPSS, Stata and Systat Files

# 1 package for all 3: foreign

# SPSS: mySPSSData <- read.spss("example.sav", to.data.frame = TRUE, use.value.labels = FALSE)
## use.value.labels = FALSE if you don't want the variables and their value lables to be converted into R factors

# Stata: myStataData <- read.dta("<Path to file>")
# Systat: mySystatData <- read.systat("<Path to file>") 


## SAS Files

# package: sas7bdat
# syntax: mySASData <- read.sas7bdat("example.sas7bdat")

# Resources ---------------------------------------------------------------

## https://www.datacamp.com/community/tutorials/r-data-import-tutorial#gs.tZoSnLA
## https://www.datacamp.com/community/tutorials/r-tutorial-read-excel-into-r#gs.rrcKqes
## http://www.statmethods.net/interface/packages.html
## https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html
## http://stats.idre.ucla.edu/r/faq/how-does-r-handle-missing-values/
## http://www.milanor.net/blog/read-excel-files-from-r/
