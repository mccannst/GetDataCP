# run_analysis.R
# Coursera: Getting and Cleaning Data

# read the features into a table
featdf <-read.table("features.txt")
# make a vector of the feature names
varnames <- featdf$V2
# make the feature names vector into characters for easy column names.
varnames <-as.character(varnames)

# read the data files into tables
xtest <-read.table("X_test.txt")
xtrain <- read.table("X_train.txt")

#read the activity files into tables (these will be our activity columns)
ytrain <- read.table("y_train.txt")
ytest <- read.table("y_test.txt")

#read the subject file into a table (this will be our subject column)
subtest <-read.table("subject_test.txt")

#Combine Activity and Subject into Test Table
alltest <- cbind(subtest,xtest)
alltest <- cbind(ytest,alltest)

#Combine Activity and Subject into Train Table
alltrain <- cbind(subtrain,xtrain)
alltrain <- cbind(ytrain,alltrain)

#Combine Test and Training Tables
masterset <- rbind(alltest,alltrain)

#Add proper column names to the master set
colnames(masterset) <- c("Activity","Subject", varnames)

# Step 2
#Extract only the measurements on the mean and standard deviation for
#each measurement
# assign the master set Column names to a vector, in case we mess up.
colstrings <- colnames(masterset)
# look for the strings "mean" and "std" in the column names and return
# their indices in separate vectors
meanvec <- grep("mean", colstrings)
stdvec <- grep("std", colstrings)
#combine those vectors
meanstdvec <- c(meanvec, stdvec)
#sort the resulting vector for quick human-readability
sort(meanstdvec)
#make the new table with only the subject(col1), activity(col2),
#mean and standard columns.
meanstdmaster <- masterset[,c(1,2,meanstdvec)]

# Step 3
# Assign descriptive activity names to the activites column
# get a list of the activities into a vector
actlabels <- read.table("activity_labels.txt")
actlabels <- actlabels$V2
# use the FACTOR function to assign labels and levels to a temporary vector
activitytext <- factor(meanstdmaster$Activity, levels = c(1:6), labels = (actlabels))
# finally, assign the temporary vector to the master data set as the activity
# column
meanstdmaster$Activity <- activitytext



