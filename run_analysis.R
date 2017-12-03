
## get the current directory
getwd()

## set the directory
setwd("F:/R/datafiles/UCI HAR Dataset/")

## Read Features and Activity Labels
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

##read test & train data
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

subject_train <- read.table("./train/subject_train.txt")
X_train <-  read.table("./train/X_train.txt")
y_train <-  read.table("./train/y_train.txt")

## 1.Merges the training and the test sets to create one data set

##adding column name to the subject files
names(subject_test) <- "subject"
names(subject_train) <- "subject"

## adding column names to label files
names(y_test) <- "ActivityId"
names(y_train) <-"ActivityId"

## adding column names to the measurement files
names(X_test) <- features[,2]
names(X_train) <- features[,2]

## combining the columns
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)

#Merging data
mergeData <- rbind(train_data, test_data)


##2.Extracts only the measurements on the mean and standard deviation for each measurement

meanstd <- grepl("mean|std", names(mergeData))

meanstd[1:2] <- TRUE

mergeData <- mergeData[,meanstd]

##3.Uses descriptive activity names to name the activities in the data set

mergeData$ActivityId <- factor(mergeData$ActivityId, 
                               labels=c("Walking","Walking Upstairs", 
                                        "Walking Downstairs", "Sitting", 
                                        "Standing", "Laying"))

##4.Appropriately labels the data set with descriptive variable names.

names(mergeData) <- gsub("-mean\\(\\)", "Mean", names(mergeData))
names(mergeData) <- gsub("-std\\(\\)", "StDev", names(mergeData))
names(mergeData) <- gsub("BodyBody", "Body", names(mergeData))
names(mergeData) <- gsub("X$", "X-Axis",names(mergeData))
names(mergeData) <- gsub("Y$", "Y-Axis",names(mergeData))
names(mergeData) <- gsub("Z$", "Z-Axis",names(mergeData))

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Creating tidy data set
library(reshape2)

melted <- melt(mergeData, id=c("subject","ActivityId"))

tidy_data <- dcast(melted, subject+ActivityId ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.names=FALSE)
