## assumes Samsung data is in the working directory
library(gdata) 
library(dplyr) 
#
trainData <- read.table("X_train.txt")
testData  <- read.table("X_test.txt")
features  <- read.table("features.txt")
## Activity Labels
trainLabel  <- read.table("y_train.txt")
testLabel  <- read.table("y_test.txt")
actLabels   <- read.table("activity_labels.txt",col.names=c("ActNum","ActLabel"))
## Subject info
trainSubjects <- read.table("subject_train.txt")
testSubjects <- read.table("subject_test.txt")

## Step 1 Merges the training and the test sets to create one data set.
mergedTTdata <- rbind(trainData,testData)
# Set column names for the merged training & test data based on features
names(mergedTTdata) <- as.character(features[,2])
#merged Activity 
mergedAct <- rbind(trainLabel,testLabel)
names(mergedAct) <- c("Activity")
# merged subjects
mergedSub <- rbind(trainSubjects,testSubjects)
names(mergedSub) <- c("Subject")
## Temp merged data  - Train, Test, Subject and Activity
TempMergedData <- cbind(mergedAct, mergedSub, mergedTTdata )

## Step 2.Extracts only the measurements on the mean and standard deviation for each measurement.
ColofInterest <- matchcols(TempMergedData, with=c("Subject","Activity","-mean()", "-std()"), method="or")
ColofInterestList <- c(ColofInterest$Activity, ColofInterest$Subject, ColofInterest$'-mean()',ColofInterest$'-std()')
MeanStdData <- TempMergedData[,ColofInterestList]

## Step 3. Uses descriptive activity names to name the activities in the data set
MeanStdDatawLabel <- merge(MeanStdData,actLabels,by.x="Activity",by.y="ActNum")

## Step 4. Appropriately labels the data set with descriptive variable names. 
Covered in step 1  - also refer code book
names(MeanStdDatawLabel) <- make.names(names(MeanStdDatawLabel), unique = TRUE)

## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
activity and each subject.
finalData <- aggregate(list(name = MeanStdDatawLabel), list(Activity = MeanStdDatawLabel$ActLabel, Subject = MeanStdDatawLabel
                                                            $Subject), mean, na.rm = TRUE)

Remove duplicate columns & updating column headings
finalTidyData = finalData[,c(1:2,5:83)]
names(finalTidyData) <- gsub("name.", "", names(finalTidyData))
#convert the columns with average as numeric
for(i in 3:ncol(finalTidyData)) {
  finalTidyData[,i] <- as.numeric(as.character(finalTidyData[,i]))
}
# Creating a ndependent tidy data set in working directory
write.table(finalTidyData , file=".\\SamsungTidyData.txt",row.name=FALSE)
