#This script produces the results ask in the Getting and Cleaning Data Course Project.
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#=================================================================================
#Step0 - Prepare the project environment
#=================================================================================
#set working directory
setwd(".")

#load package dependencies
if("reshape" %in% rownames(installed.packages()) == FALSE){ 
  install.packages("reshape")
}
if("plyr" %in% rownames(installed.packages()) == FALSE){ 
  install.packages("plyr")
}
library(plyr)
library(reshape)

#download, unzip, and rename data directory => data
if (!file.exists("./data")) {
  fileName = format(Sys.Date(),"./%Y%m%d_data.zip") 
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = fileName, method = "curl")
  unzip(fileName)
  file.rename("./UCI HAR Dataset","data")
}

getFileName <- function(fileName){
  paste("./data/", fileName, sep="")
}

#===================================================================
#step 1
#===================================================================
#read activities
activities = read.table(getFileName("activity_labels.txt"))
colnames(activities) <- c("id", "activityName")

#read features
features =read.table(getFileName("features.txt"))
colnames(features) <- c("id", "featureName")

#combine test subjects, feactures, activities
test_subjects = read.table(getFileName("test/subject_test.txt"))
test_features = read.table(getFileName("test/X_test.txt"))
test_activities = read.table(getFileName("test/y_test.txt"))
colnames(test_features) <- features$featureName
test_features <- cbind(subject=test_subjects$V1, activity=test_activities$V1, test_features)

#compain train subjects, feactures, activities
train_subjects = read.table(getFileName("train/subject_train.txt"))
train_features = read.table(getFileName("train/X_train.txt"))
train_activities = read.table(getFileName("train/y_train.txt"))
colnames(train_features) <- features$featureName
train_features <- cbind(subject=train_subjects$V1, activity=train_activities$V1, train_features)

#merge training set and test set.
data <- join_all(list(test_features, train_features), by=c("subject"), type="full")

#=====================================================================
#step2 - extract only mean and std columns
#=====================================================================
meanStdCols <- features$featureName[grepl("^[tf](.*)([Mm]ean|[Ss]td)",features$featureName)]
meanStdCols <- c(c("subject", "activity"), as.character(meanStdCols))
data <- data[,meanStdCols]

#=====================================================================
#step3 - create variable descriptive names
#=====================================================================
meanStdCols <- gsub("\\(\\)", "", meanStdCols)  
camel <- function(x){ #function for camel case
  capit <- function(x) paste0(toupper(substring(x, 1, 1)), substring(x, 2, nchar(x)))
  cam <- function(x) paste(capit(x), collapse="")
  t2 <- strsplit(x, "-")
  sapply(t2, cam)
}  
#Camel case all the column names
meanStdCols <- camel(meanStdCols)

#=======================================================================
#step4 - assign descriptive names to data columns
#=======================================================================
colnames(data) <- meanStdCols

#=======================================================================
#step5 - create TIDY dataset
#=======================================================================
measuredColumns <- meanStdCols[3:length(meanStdCols)]

#generate the mean for all measured variables
tidy <- aggregate(data[measuredColumns],by=data[c("Subject","Activity")], FUN=mean)

#Produce a long format from the wide data format to make my variable descriptions simpler
tidy <- melt(tidy, id=c("Subject","Activity"), measured=measuredColumns) 

#order the data so that it is easier to understand
tidy <- tidy[order(tidy$Subject, tidy$Activity),]

#assign names to the tidy dataset
colnames(tidy) <- c("Subject", "Activity", "MeasuredVariable", "MeasuredVariableMean")

#write the tidy dataset to a file
write.table(tidy, file="tidy_data.txt",row.names=FALSE, na="",col.names=TRUE, sep=",")

#read tity data back to verify the correctness of the file above
#tidy <- read.table("tidy_data.txt",  header=TRUE, sep=",")
