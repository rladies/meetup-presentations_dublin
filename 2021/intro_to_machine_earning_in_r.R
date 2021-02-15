### Intro to Machine Learning in R ###

## Kmeans clustering
## Knn classification
## Logistic regression
## Classification trees
## Bootstrapping
## Training, validation, testing
## K-fold cross validation
## Bagging
## Random Forests

# install required packages
# install.packages("tidyverse")
# install.packages("cluster")
# install.packages("factoextra")
# install.packages("gridExtra")
# install.packages("class")
# install.packages("MASS")
# install.packages("ROCR")
# install.packages("gclus")
# install.packages("rpart")
# install.packages("partykit")
# install.packages("adabag")
# install.packages("nnet")
# install.packages("randomForest")


### Clustering ###

# Load libraries
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization
library(gridExtra)  # grid graphics


# Start by loading a built-in R dataset
df <- USArrests

# Take a look at the data set
head(df)

# Remove missing values 
df <- na.omit(df)

# Scale the dataset to remove any arbitrary variable unit
df <- scale(df)
head(df)

# Compute the difference between the rows of the matrix
distance <- get_dist(df)

# Visualise the distance between rows where red represents a large distance and teal represents a small distance
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# Compute k-means using two clusters
k2 <- kmeans(df, centers = 2, nstart = 25)
str(k2)
k2$cluster

# Visualuse the clusters
fviz_cluster(k2, data = df)

# Compute kmeans using various values of k
k3 <- kmeans(df, centers = 3, nstart = 25)
k4 <- kmeans(df, centers = 4, nstart = 25)
k5 <- kmeans(df, centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = df) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = df) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = df) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = df) + ggtitle("k = 5")

grid.arrange(p1, p2, p3, p4, nrow = 2)

# Determining optimal clusters
set.seed(1234)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(df, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

# Neater function
fviz_nbclust(df, kmeans, method = "wss")

# function to compute average silhouette for k clusters
avg_sil <- function(k) {
  km.res <- kmeans(df, centers = k, nstart = 25)
  ss <- silhouette(km.res$cluster, dist(df))
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 15
k.values <- 2:15

# extract avg silhouette for 2-15 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes")

# Neater function
fviz_nbclust(df, kmeans, method = "silhouette")

# Compute k-means clustering with k = 4
set.seed(123)
final <- kmeans(df, 4, nstart = 25)
print(final)

# Visualise the clusters
fviz_cluster(final, data = df)

# Summarise the clusters
USArrests %>%
  mutate(Cluster = final$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")


### KNN ###

# Load the package class
library(class)

# Load the iris data
df <- data(iris)
head(iris) 

# Scale first 4 coulumns of dataset because they are the predictors
iris_norm <- scale(iris[,c(1,2,3,4)])

summary(iris_norm)

# Generate a random number that is 90% of the total number of rows in dataset.
ran <- sample(1:nrow(iris), 0.9 * nrow(iris)) 

# Extract training set
iris_train <- iris_norm[ran,] 

# Extract testing set
iris_test <- iris_norm[-ran,]

# Extract 5th column of train dataset because it will be used as 'cl' argument in knn function.
iris_target_category <- iris[ran,5]

# Extract 5th column if test dataset to measure the accuracy
iris_test_category <- iris[-ran,5]

# Run knn function
pr <- knn(iris_train,iris_test,cl=iris_target_category,k=13)

# create confusion matrix
tab <- table(pr,iris_test_category)

# This function divides the correct predictions by total number of predictions that tell us how accurate teh model is.

accuracy <- function(x){sum(diag(x)/(sum(rowSums(x)))) * 100}
accuracy(tab)


# Logistic Regression

#Load the MASS package
library(MASS)

# Load the data
data(birthwt)
head(birthwt)
str(birthwt)

# Ensure that any categorical variables are coded as factors.
birthwt$race<-as.factor(birthwt$race)
birthwt$smoke<-as.factor(birthwt$smoke)
birthwt$ht<-as.factor(birthwt$ht)
birthwt$ui<-as.factor(birthwt$ui)

str(birthwt)

# Fit the model
fit<-glm(low~age+lwt+race+smoke+ptl+ht+ui+ftv,data=birthwt
         ,family="binomial")
summary(fit)

#Predict the response variable for each value
predict(fit)

#Predict the response variable for each value
pred <- predict(fit,type="response")
pred


#Load the ROCR library
library(ROCR)
#Take the predicted probabilities from earlier and the observed response
#patterns and pass them throughthe prediction() command
predobj<-prediction(pred,birthwt$low)

# Complete the TPR and FPR for the model (as the treshold varies).
# Many other performance measures can be computed using the
# performance() command.
# Read the help command for the function to look at these.
perf <- performance(predobj,"tpr","fpr")

#Plot the ROC curve.
plot(perf)

### Classification Trees ###

# Load the required packages
library(gclus) 
library(rpart)
library(partykit)

# Load the wine data
data(wine)
head(wine)
str(wine)

# Ensure that Class is categorical
is.factor(wine$Class)
wine$Class <- as.factor(wine$Class)

# Split the data
# 75% of values are used as training data
# The remaining 25% are used as test data

N <- nrow(wine)
indtrain <- sample(1:N,size=0.75*N)
indtrain <- sort(indtrain)
indtest <- setdiff(1:N,indtrain)

# Fit a classifier to only the training data
fit.r <- rpart(Class~.,data=wine,subset=indtrain)
plot(as.party(fit.r))

# Classify for ALL of the observations
pred <- predict(fit.r,type="class",newdata=wine)

# Look at the results for the test data only
pred[indtest]

# Look at table for the test data only (rows=truth, cols=prediction)
tab <- table(wine$Class[indtest],pred[indtest])
tab

# Work out the accuracy
sum(diag(tab))/sum(tab)

# Look at the results for the training data only
tab <- table(wine$Class[indtrain],pred[indtrain])
tab

# Work out the accuracy
sum(diag(tab))/sum(tab)


# Let's repeat this process to see if we were just unlucky!

# Set up res to store results

res<-matrix(NA,100,2)

# Start simulation to look at this 
iterlim <- 100
for (iter in 1:iterlim)
{
  
  # Split the data
  # 75% of values are used as training data
  # The remaining 25% are used as test data
  N <- nrow(wine)
  indtrain <- sample(1:N,size=0.75*N)
  indtrain <- sort(indtrain)
  indtest <- setdiff(1:N,indtrain)
  
  # Fit a classifier to the training data only
  fit.r <- rpart(Class~.,data=wine,subset=indtrain)
  
  # Classify for ALL of the observations
  pred <- predict(fit.r,type="class",newdata=wine)
  
  # Look at table for the test data only (rows=truth, cols=prediction)
  tab <- table(wine$Class[indtest],pred[indtest])
  
  # Work out the accuracy
  res[iter,1]<-sum(diag(tab))/sum(tab)
  
  # Look at the results for the training data only
  tab <- table(wine$Class[indtrain],pred[indtrain])
  
  # Work out the accuracy
  res[iter,2] <- sum(diag(tab))/sum(tab)
  
} 


# Check out the error rate summary statistics.
colnames(res)<-c("test","train")
apply(res,2,summary)

### Bootstrapping ###

# Using bootstrapping to build training and test data

# Set seed of random number generator
set.seed(1000)

# Load the wine data
# The gclus package is needed just for the data
library(gclus) 
data(wine)

# Ensure that Class is categorical
is.factor(wine$Class)
wine$Class <- as.factor(wine$Class)

# Load the rpart and partykit libraries
library(rpart)
library(partykit)

# Bootstrap the data
# Use the bootstrap sample as training data
# Test the model on the remainder of the data
N <- nrow(wine)
indtrain <- sample(1:N,replace=TRUE)
indtrain <- sort(indtrain)
indtest <- setdiff(1:N,indtrain)

# Fit a classifier to only the training data
fit.r <- rpart(Class~.,data=wine,subset=indtrain)
plot(as.party(fit.r))

# Classify for ALL of the observations
pred <- predict(fit.r,type="class",newdata=wine)

# Look at the results for the test data only
pred[indtest]

# Look at table for the test data only (rows=truth, cols=prediction)
tab <- table(wine$Class[indtest],pred[indtest])
tab

# Work out the accuracy
sum(diag(tab))/sum(tab)

# Look at the results for the training data only
tab <- table(wine$Class[indtrain],pred[indtrain])
tab

# Work out the accuracy
sum(diag(tab))/sum(tab)

### Comparing Classifiers ###

# Comparing classifiers using training, validation and test

# Set seed of random number generator
set.seed(1000)

# Load the wine data
# The gclus package is needed just for the data
library(gclus) 
data(wine)

# Ensure that Class is categorical
is.factor(wine$Class)
wine$Class <- as.factor(wine$Class)

# Load the rpart and partykit libraries
library(rpart)
library(partykit)

# Sample 50% of the data as training data
# Sample 25% of the data as validation 
# Let the remaining 25% data be test data

N <- nrow(wine)
indtrain <- sample(1:N,size=0.50*N,replace=FALSE)
indtrain <- sort(indtrain)
indvalid <- sample(setdiff(1:N,indtrain),size=0.25*N)
indvalid <- sort(indvalid)
indtest <- setdiff(1:N,union(indtrain,indvalid))

# Fit a classification tree to only the training data
fit.r <- rpart(Class~.,data=wine,subset=indtrain)
plot(as.party(fit.r))

# Fit a logistic regression to the training data only too
# First load the nnet package
library(nnet)
fit.l <- multinom(Class~., data=wine,subset=indtrain)

# Classify for ALL of the observations
pred.r <- predict(fit.r,type="class",newdata=wine)
pred.l <- predict(fit.l,type="class",newdata=wine)

# Look at table for the validation data only (rows=truth, cols=prediction)
tab.r <- table(wine$Class[indvalid],pred.r[indvalid])
tab.r
tab.l <- table(wine$Class[indvalid],pred.l[indvalid])
tab.l

# Work out the accuracy
acc.r <- sum(diag(tab.r))/sum(tab.r)
acc.l <- sum(diag(tab.l))/sum(tab.l)

acc.r
acc.l

# Look at the method that did best on the validation data 
# when applied to the test data
if (acc.r>acc.l)
{
  tab <- table(wine$Class[indtest],pred.r[indtest])
}else
{
  tab <- table(wine$Class[indtest],pred.l[indtest])
}

tab

sum(diag(tab))/sum(tab)

### K-fold cross validation
# Using k-fold cross validation

# Set seed of random number generator
set.seed(1000)

# Load the wine data
# The gclus package is needed just for the data
library(gclus) 
data(wine)

# Ensure that Class is categorical
is.factor(wine$Class)
wine$Class <- as.factor(wine$Class)

# Load the rpart and partykit libraries
library(rpart)
library(partykit)

# Fit a classifier to all of the training data
fit.r <- rpart(Class~.,data=wine)
plot(as.party(fit.r))

# Let's do some k-fold cross validation

# First, let's assign the observations to folds.
K <- N
folds <- rep(1:K,ceiling(N/K))
folds <- sample(folds) 
folds <- folds[1:N]

# Set up res to store results

res<-matrix(NA,K,1)

# We will need to drop each fold in turn.
iterlim <- K
for (iter in 1:iterlim)
{
  indtrain <- (1:N)[!(folds==iter)]
  indtest <- setdiff(1:N,indtrain)
  
  # Fit a classifier to only the training data
  fit.r <- rpart(Class~.,data=wine,subset=indtrain)
  
  # Classify for ALL of the observations
  pred.r <- predict(fit.r,type="class",newdata=wine)
  
  # Look at table for the validation data only (rows=truth, cols=prediction)
  tab.r <- table(wine$Class[indtest],pred.r[indtest])
  
  # Let's see how well we did on the fold that we dropped
  res[iter,1] <- sum(diag(tab.r))/sum(tab.r)
  
} 


# Check out the error rate summary statistics.
colnames(res)<-c("test")
apply(res,2,summary)


### Bagging ###

# Load the adabag library
library(adabag)

# Load the wine data
library(gclus)
data(wine)
wine$Class<-as.factor(wine$Class)

# Implement Bootstrap Aggregating
fit.b <- bagging(Class~.,data=wine)
pred.b <- predict(fit.b,newdata=wine,type="class")$class

# Fit a classification tree (same data)
fit.r <- rpart(Class~.,data=wine)
pred.r <- predict(fit.r,newdata=wine,type="class")

# Compare performance
tab.b <- table(wine$Class,pred.b)
tab.r <- table(wine$Class,pred.r)

sum(diag(tab.b))/sum(tab.b)
sum(diag(tab.r))/sum(tab.r)

# Plot examples of 9 trees
library(partykit)
par(mfrow=c(3,3))
for (j in 1:9)
{
  plot(fit.b$trees[[j]],main=paste("Example ",j,sep=""))
  text(fit.b$trees[[j]],use.n=TRUE,xpd=TRUE,col="red")
}
par(mfrow=c(1,1))

### Random Forests ###

# Load the randomForest package
library(randomForest)

# Load the wine data
library(gclus)
data(wine)
wine$Class <- as.factor(wine$Class)

# Implement the random forest algorithm
fit.rf <- randomForest(Class~.,data=wine)

# Examine the results
fit.rf

# Let's look at variable importance
varImpPlot(fit.rf)












