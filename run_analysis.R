## Reading data from text file

#### # 1. To merge the training and the test sets to create one data set. #####

X_test <- read.table("test/X_test.txt", quote="\"")

X_train <- read.table("train/X_train.txt", quote="\"")

subject_test <- read.table("test/subject_test.txt", quote="\"")

subject_train <- read.table("train/subject_train.txt", quote="\"")

y_test <- read.table("test/y_test.txt", quote="\"")

y_train <- read.table("train/y_train.txt", quote="\"")

## reading features table 

features <- read.table("features.txt", quote="\"")

## merging datasets 

mergedData <- rbind(X_test, X_train)

mergedSubject <- rbind(subject_test, subject_train)

mergedY <- rbind(y_test, y_train)

## setting names for merged Data Frame

colnames(mergedData) <- features$V2

#### # 2. Extracts only the measurements on the mean and standard deviation for each measurement. ####

subsetedData <- mergedData[, grep("mean\\(\\)|std\\(\\)", features$V2)]
names(subsetedData) <- tolower(names(subsetedData)) # last slide of editing text variable of week 4

#### # 3. Uses descriptive activity names to name the activities in the data set ####

activityLabels <- read.table("activity_labels.txt", quote="\"", col.names = c("Activity ID", "Activity Names"))
activityLabels$Activity.Names <- gsub("_", " ", tolower(as.character(activityLabels$Activity.Names)))
mergedY$V1 <- activityLabels[mergedY$V1, 2]
names(mergedY) <- "activity"

#### # 4. Appropriately labels the data set with descriptive activity names. ####

names(mergedSubject) <- "subject"
newDataSet <- cbind(mergedSubject, mergedY, subsetedData)
write.table(newDataSet, "mergedCleanData.txt")

#### # 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject. ####

library(reshape)
mdata <- melt(newDataSet, id = c("subject", "activity"))
activityAverage <- cast(mdata, activity~variable, mean)
subjectAverage <- cast(mdata, subject~variable, mean)
## in order to submit the result in one .txt file
## binding both the dataset in one txt file.

names(activityAverage)[1] <- "subject"
dataWithAvaerage <- rbind(activityAverage, subjectAverage) 
names(dataWithAvaerage)[1] <- "Activity/Subject"
write.table(dataWithAvaerage, "CombinedTidyDataSet.txt")
