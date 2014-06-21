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
