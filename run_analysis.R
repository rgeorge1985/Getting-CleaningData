## Getting and Cleaning Data: Week 4 | Course Project
## --------------------------------------------------

#This R script called run_analysis.R performs following tasks

#1.  Create one data set by merging the training and the test sets
#2.  Extract the mean and standard deviation column names and data
#3.  Process data using descriptive activity names to name the activities in the data set
#4.  Appropriately labels the data set with descriptive variable names.
#5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Load required libraries
## -----------------------
library(data.table)   
# data.table inherits from data.frame. It offers fast and nemory efficient: file reader and writer, aggregations, updates, equi, non-equi, rolling, range and interval joins, in a short and flexible syntax, for faster development.


library(reshape2)
#This function reshapes a data frame between 'wide' format with repeated measurements in separate columns of the same record and 'long' format with the repeated measurements in separate records

## Set the working directory
## -------------------------

setwd("C:/Users/Ron.George/Desktop/Data Science John Hopkins/3. Data Cleanup")

#Download and save file to working directory
# File URL to download
filelink <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# Directory and filename (txt or csv) of the clean/tidy data:
tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"
# tidyDataFileAVG <- "./tidy-UCI-HAR-dataset-AVG.csv"
# Directory and filename (.txt) of the clean/tidy data
tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"


## Download the dataset (. ZIP) and unzip into working folder if file does not exist
## ---------------------------------------------------------------------------------

if(!file.exists(destfile)){
  res <- tryCatch(download.file(filelink,
                                destfile="dataset.zip",
                                method="auto"),
                  error=function(e) 1)
  if(dat!=1) load("dataset.zip") 
}

unzip("dataset.zip")


## 1. Create one data set by merging the training and the test sets :
## ------------------------------------------------------------------

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Combines data table (train vs test) by rows
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)



## 2. Extract the mean and standard deviation column names and data
## ----------------------------------------------------------------

# Read features labels
features <- read.table("./UCI HAR Dataset/features.txt")
# Friendly names to features column
names(features) <- c('feat_id', 'feat_name')
# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
# Replaces all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))



## 3. Uses descriptive activity names to name the activities in the data set:
## --------------------------------------------------------------------------

# Read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Friendly names to activities column
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]


## 4. Process data using descriptive activity names to name the activities in the data set
## ---------------------------------------------------------------------------------------

names(y) <- "Activity"
names(s) <- "Subject"

# Combines data table by columns
tidyDataSet <- cbind(s, y, x)



## 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject:
## ----------------------------------------------------------------------------------------------------------------

p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"# Created csv (tidy data set) in diretory


# Created csv (tidy data set) in diretory
write.table(tidyDataSet, tidyDataFile)
# Created csv (tidy data set AVG) in diretory
# write.csv(tidyDataAVGSet, tidyDataFileAVG)
# Created txt (tidy data set AVG) in diretory
write.table(tidyDataAVGSet, tidyDataFileAVGtxt)