# Data Analysis steps - example
# step 1 - Define the question - Can i use quantaive characteristics of the emails to classify email as SPAM/HAM? emails?
# Step 2 - Define the ideal data set (emails from Google data center)
# Step 3 - Determine what data you can access (UCL machine learning from HP)
# Setp 4 - Obtain the data
# Setp 5 - Clean the data
library(kernlab)
data(spam) # already cleaned data
str(spam[,1:5])
#sub sampling of the dataset
set.seed(3435)
trainIndicator = rbinom(4601, size=1,prob=0.5) # use 50% rbinom to split data
table(trainIndicator)
trainSpam <- spam[trainIndicator==1,]
testSpam <- spam[trainIndicator==0,]
# Step 5 - Exploratory Data analysis 
# Look at summary, look at the distribution, relationships
names(trainSpam) # data contains list of words and frequency they occur
table(trainSpam$type) # email is classificed as spam or non spam
plot(log10(trainSpam$capitalAve+1)~ trainSpam$type) # box plot taking Captial letters
plot(log10(trainSpam[,1:4]+1)) # Plotting first few variables
# clustring - to determine which variables predicts spam
hCluster = hclust(dist(t(trainSpam[,1:57]))) 
plot(hCluster)
# clustering using log 10 values
hClusterUpdated = hclust(dist(t(log10(trainSpam[,1:55]+1)))) 
plot(hClusterUpdated)
# Step 6 - Statistical Prediction - apply simple linear model to find CVerror for each variables
trainSpam$numType = as.numeric(trainSpam$type)-1
costFunction = function(x,y) sum(x != (y > 0.5))
cvError = rep(NA,55)
library(boot)
for (i in 1:55) { 
        lmFormula = reformulate(names(trainSpam)[i], response = "numType")
        glmFit = glm(lmFormula, family = "binomial", data = trainSpam)	
        cvError = cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}
names(trainSpam)[which.min(cvError)]
# Setp 7 - Interpret results
# Setp 8 - Challenge results
# Setp 9 - Synthesize/write up results
# Step 10 - Create reproducible code 