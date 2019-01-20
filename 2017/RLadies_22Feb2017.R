# Introduction to R -----------------------------------------------------------------------

# A language for data analysis and graphics. (R&R in 1996)
# open source: free, user-developer, community, advancements, flexibility

# syntax - the grammar of the language
# semantics - the meaning behind the sentence

# open R Console - separate windows, documents... usable but not user friendly...

# RStudio -----------------------------------------------------------------

# RStudio is an Integrated Development Environment (IDE)
# used to simplify and organise the coding environment

# 4 windows in one:

## source editor - write your code and save for later (file vs project)

## console - commands are run here (are evaluated)

## workspace/environment // history: to console/ to source (!)
# it includes any user-defined objects (vectors, 
# matrices, data frames, lists, functions)
# you can save and load your workspace as an .RData file

# memory usage R is designed as an in-memory application: 
# all of the data you work with must be hosted in the RAM 
# of the machine you're running R on.
# There is a MS Server for R called Revolution R Enterprise 
# When working with large data sets in R, it's important 
# to understand how R allocates, duplicates and consumes memory
# http://adv-r.had.co.nz/memory.html - Hadley Wickham


## files - select your working directory here or in the source editor
getwd()
setwd("nameofyourdirectory")

## plots (history), can be exported as .pdf or .jpg
## packages - tick mark
## help
# help on functions, objetcs through source editor
?vector
??bar #barchart package I heard about at last meetup
# package
help(package = graphics)

# Source editor -----------------------------------------------------------------

## take a closer look at the icons
# navigate thorugh scripts
# sourcing a script = sending entire script to the console
# search
# tools - text completion with tab
# report - markdown
# run / source


# to add a section divider press cmnd(ctrl) + shift + r and add a label
# or go to Code/Insert Section
# you can use Code/Jump to cmnd(ctrl) + alt + shift + j
# and you can collapse the entire section!

# breakpoint - red dot
# can be added to a section break or to an expression
# but not to a comment
example <- 'this example is to show that you can add a breakpoint to an expression'
# RStudio will open the debugger mode when it encounters a breakpoint while executing code


# Comments -----------------------------------------------------------------

# <hashtag> starts a comment R does not support multi-line comments or comment
# blocks cmnd(ctrl) + shift + c adds/removes hashtag or go to Code ->
# Comment/Unocmment Lines


# Expressions -------------------------------------------------------------

# we write expressions in the R script
# through expressions we create variables 
# variables store a value or a function and help us retrieve it easily

# this is an example of an expression
x <- 1
# we assign a variable x value 1
# (x is a symbol; <- is an assignment operator; 1 is a value)
# we read this expression 'x is 1'

# controversial assignment operator, '=' added in 2001
x = 1
x
x <<- 1 # <<- used in functions (closures - functions written by other functions) 
x

x <-        ## this is an incomplete expression
x

# '' " " strings
Msg <- 'hello'
Msg


# R is CaSE SEnsiTive

x
# auto-printing - more common in interactive work
print(x) # explicit printing with a print() function - used with scripts, functions, etc.
x <- 0:5
  
x
# take a look at the output in the console
# 1 is an R object, more specifically a vector, [1] is an index, nb not 0 like in case of other
# programming languages, index is not part of the vector, it's only
# a printed output to make it more legible

# Manage environment from the console -------------------------------------------------------------

ls()
rm("Msg", "x")
y <- 1
exists("y")
rm("y")

# Object classes ----------------------------------------------------------

# R objects - everything we manipulate in R
# there are 5 basic classes (aka atomic modes) of objects:
## - character
## - numeric (real numbers)
## - integer
## - complex
## - logical (T/F) (logical operations: & | !)

# we can check a class of an object with class() function

x <- 1
x
class(x)

1 ## real number object: 1.00
1L ## if we want an integer, we need to add an 'L' suffix

x <- 1L
x
class(x)

# R objects can have attributes (not all objects have attributes)
# - class
# - length (number of elements)
# - name
# - dimension (matrix, data frame)
# - user defined attributes 

# The most basic object is a vector
# A vector can only contain objects of the same class
# e.g. vector of characters or vector of integers

# Vectors -----------------------------------------------------------------


# A vector is a sequence of data elements of the same basic type.

x <- 1
x
is.vector(x)

# there are no scalars in R; x is a numeric vector that has one element and
# it is a number 1


# There are a couple of ways of creating vectors:

# with  vector() function
# it takes 2 arguments: object class and length of the vector

x <- vector('logical', length = 20)
x

# c() function, we can think of it as 'concatenate'
# examples of vectors of 2 members/components
x <- c(0.1, 0.2)
x
x <- c(TRUE, FALSE)
x
x <- c(T, F)
x
x <- c('peas', 'carrots')
x
x <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
x
x <- 0:100
x
x <- c(1+0i, 2+4i)
x

# remember same class!! is the below wrong??
x <- c(9, TRUE)
class(x)


# value COERCION when combining vectors - "least common denominator", 
# to maintain the same primitive data type for 
# members in the same vector

y <- c(1.6, 'carrots')
y
# numeric as character

y <- c(2, 3.2)
y
class(y)
# integer as numeric

y <- c(TRUE, 2L)
y
# logical as numeric: T = 1, F = 0 
class(y)

y <- c("cat", F)
y
# logical as character

y <- c(2, 3.2, 1+3i)
y
class(y)
# numeric/integer as complex


# coercion:
# character + any other class = character
# integer + numeric = numeric
# complex + integer/numeric = complex
# numeric + logical = numeric
# integer + logical = integer

# explicit coercion (you can change a class of an object) - as.*() function
x <- 1
class(x)


as.integer(x) # we call as.numeric on x
as.logical(x)
as.character(x)
x
class(x)

y <- as.character(x)
y
class(y)

as.logical(0)


# Nonsensical coercion results in NA values (Not Available)
x <- c("a", "b", "c")
as.integer(x)
as.numeric(x)
as.logical(x)
as.complex(x)

?as.integer()
x <- 0:24565
# length of a vector - function length()
length(x)


# Lists -------------------------------------------------------------------

# special type of vector that can contain elements of different classes

x <- list(c(0:22), c("a", "b"))
x
# take a look at how it's printed
x[[1]][2]
class(x)
# member reference [] and [[]]
x[2]
x[c(1:4)]

x <- list(c(2, 1, 4), c("carrots", "peas", ""))
x[2]
x[[2]]

sapply(x, '[[', 3)

# Vector index ------------------------------------------------------------

# index - retrieveing a component of a vector / slicing
x <- 0:10
x[2]
# negative index
x[-c(1:4)] #removes the component with the absolute value
# out of range index
x[15] 
# more than 1 component
x[c(2, 3)]
x[c(1,2,2, 2, 2)] # duplicate index
x[1:4] ## range index

x[(length(x)-1):length(x)]

tail(x, 2)

x[11:8]

# VECTORISATION - Arithmetic operations on vectors ---------------------------------------------------

# arithmetics coded in C - vectorized functions which
# can operate on entire vectors at once

# vectorisation means that many functions that are 
# to be applied individually to each element in a
# vector of numbers require a loop assessment 
# to evaluate; however, in R many of these functions 
# have been coded in C to perform much faster than a
# for loop would perform

x <- c(1, 3, 4, 5)
y <- c(1, 2, 6, 6)
x + y
x * y
x - y
x / y
x * 3

# vector recycling
# When performing an operation on two or more vectors
# of unequal length, R will recycle elements of 
# the shorter vector(s) to match the longest vector.

x <- c(1, 2, 3, 4, 5, 6)
y <- c(1, 2, 3)
x + y
x * y
x - y
x / y

# When the longer object length is not a multiple
# of the shorter object length, a warning is given
even_length <- c(1, 1, 1, 1, 1, 1, 1, 1)
odd_length <- 1:3
even_length * odd_length


# Matrix ------------------------------------------------------------------

# Matrices are special vectors, with a dimension attribute,
# they are not separate classes of objects
# DIMENSION is an integer vector of length 2 (nrow, ncol)

# create a matrix with matrix() function
m <- matrix(nrow = 4, ncol = 3)
dim(m)
attributes(m)

m
# this is an empty matrix
# by default matrices are constructed column-wise, values inserted
# in the upper left corner and running down the columns

m <- matrix(1:12, nrow = 4, ncol = 3)
m
m <- matrix(1:4, nrow = 4, ncol = 3)
m

# by rows
m <- matrix(1:12, nrow = 4, ncol = 3, byrow = TRUE)
m

# slicing the matrix
m[1, 3]
m[1, ]
m[ , 3]
m[ , c(1,3)] #1st & 3rd column
m[c(2:4), ] # 2nd, 3rd & 4th row
# pay attention what happens with indexes
group <- m[c(2:4), ]
group

# it's handy for subsetting your data, e.g. you create a new set from the existing data
past_students <- m[c(2:4),]
past_students[c(2,3), 2]

# we can assign names to the rows and columns
# and then we can access the elements by names
# we create row and column names with list() function

dimnames(m) <- list(c('John', 'Mary', 'Sarah', 'Jo'),
                    c('age', 'score1', 'score2'))
m
m['Mary', 'score1']

# other ways of creating matrices:

# 1) create a vector with the c() function and add a dimension attribute 

m <- 1:12
m
dim(m)
dim(m) <- c(3,4)
m

# 2) use column-binding with cbind() function

?cbind
age <- c(20, 19, 20, 20)
score1 <- c(68, 76, 54, 72)
group <- cbind(age, score1)
group
class(group)
group2 <- cbind(group, age)
group2

# 3) use row-binding with rbind() function
student1 <- c(20, 67)
student2 <- c(19, 76)
rbind(student1, student2)

# transpose of a matrix by interchanging columns and rows
m <- rbind(x,y)
m
t(m)


# Factors -----------------------------------------------------------------

# special type of vectors
# used to represent categorical data
# like an integer vector where each integer has a label
# but sometimes it's better to use the factor with labels,
# because they are self-describing, compare male / female vs 1 / 2

# also factors are treated differently by statistical modelling functions

# unordered - categorical (male, female)
# ordered - ranked (low, medium, high), can use comparison operators

x <- factor(c('male', 'female', 'female', 'female', 'male'))
x
class(x)

table(x)

# uses the cross-classifying factors to build a contingency
# table of the counts at each combination of factor levels.

# the levels:
unclass(x) # strips out the labels to integers

# determine the baseline level - create an ordered 
x <- factor(c('Jan', 'Jul', 'Dec', 'Mar', 'Jan', 'Apr'))
x
y <- factor(c('Jan', 'Jul', 'Dec', 'Mar', 'Jan', 'Apr'),
            levels = c('Jan', 'Mar', 'Apr', 'Jul', 'Dec'))

y[1] > y[4]
y
unclass(y) # strips out the class to integers


# Missing values ----------------------------------------------------------

# NaN for undefined mathematical operations
# NA for anything else really
# can have different classes (character, numerical...)

x <- 0/0
x

is.na(x)
is.nan(x) # every NaN is NA, but not every NA is NaN

x <- c(1, 2, NA, NaN)
length(x)
is.na(x)
is.nan(x)


# Data frames -------------------------------------------------------------

# Df is data type used for storing tabular data
# special type of a list, because can store different classes
# of object in each column

# vector - list 
# matrix - data frame

# special attribute: row.names every row has a name, e.g. subject ID

# df created by data.frame(), read.table(), read.csv()
# df can be converted to a matrix by calling data.matrix()

group <- data.frame(age = c(23, 42, 28, 31), sex = c('m', 'f', 'f', 'm'))
group
nrow(group)
ncol(group)
row.names(group) # default

group <- data.frame(age = c(23, 42, 28, 31), sex = c('m', 'f', 'f', 'm'), 
                row.names = c(649:652))
group
# we changed the names of the rows, this is how you can print them:
rownames(group)

# we can update row names
row.names(group) <- c('John', 'Mary', 'Sarah', 'Patrick')

# if you want to subset your data frame, you can use an index or a row/column name
group[c(1,2), c(1:2)]
group["John", 1]
group["649", "age"]

# to print column names
names(group)
str(group)

group$age
attach(group)
age
sex

summary(group)

boxplot(group$age)

# References ---------------------------------------------------------------

# Roger Peng Johns Hopkins University (coursera + youtube)
# Bradley C. Boehmke 'Data Wrangling with R'
# statmethods.net
# r-tutor.com






