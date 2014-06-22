# run_analysis.R
# Coursera: Getting and Cleaning Data

library(reshape)

# read the features into a table
featdf <-read.table("features.txt")
# make a vector of the feature names
varnames <- featdf$V2
# make the feature names vector into characters for easy column names.
# NOTE: This is part of step 4 in the assignment
varnames <-as.character(varnames)

# read the data files into tables
xtest <-read.table("X_test.txt")
xtrain <- read.table("X_train.txt")

#read the activity files into tables (these will be our activity columns)
ytrain <- read.table("y_train.txt")
ytest <- read.table("y_test.txt")

#read the subject file into a table (this will be our subject column)
subtest <-read.table("subject_test.txt")
subtrain <-read.table("subject_train.txt")

#Combine Activity and Subject into Test Table
alltest <- cbind(ytest,xtest)
alltest <- cbind(subtest,alltest)


#Combine Activity and Subject into Train Table
alltrain <- cbind(ytrain,xtrain)
alltrain <- cbind(subtrain,alltrain)


#Combine Test and Training Tables
masterset <- rbind(alltest,alltrain)

#Add proper column names to the master set NOTE: This is also part of step 4
colnames(masterset) <- c("Subject","Activity", varnames)

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

#Step 4
# Assign descriptive variable names to the data set
# PLEASE NOTE: We did this already in step one when we made the master data set.

#Step 5
# Create a separate, tidy data set with the average of each variable for each
# activity and each subject
# First, using the reshape package, melt the data by subject and Activity
meltedmaster <- melt(meanstdmaster, id=c("Subject","Activity"))
# Second, cast the data into a new table by Subject + Activity, writing the 
# MEAN of each variable to the cells
castmaster <- cast(meltedmaster, Subject + Activity ~ variable, mean)

#Write the final, tidy dataset to a file
write.table(castmaster, "SubjActivityMeans.txt")


