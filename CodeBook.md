#run_analysis.R CodeBook


run_analysis.R was written and executes well on R version 3.1.0 (2014-04-10); "Spring Dance"

The assignment is to:
Create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


# Step 1
First, we unzip six files into the working directory:
 - features.txt
 - X_test.txt
 - X_train.txt
 - y_test.txt
 - y_train.txt
 - subject_test.txt
 
Then attach the reshape package: http://cran.r-project.org/web/packages/reshape/index.html

	library(reshape)

Read the features into a table

	featdf <-read.table("features.txt")
	
Make a vector of the feature names.

	varnames <- featdf$V2
	
Make the feature names vector into characters for easy column names.
_NOTE:_ This is part of step 4 in the assignment

	varnames <-as.character(varnames)

Read the data files into tables.

	xtest <-read.table("X_test.txt")
	xtrain <- read.table("X_train.txt")

Read the activity files into tables (these will be our activity columns)

	ytrain <- read.table("y_train.txt")
	ytest <- read.table("y_test.txt")

Read the subject files into a table (this will be our subject column)

	subtest <-read.table("subject_test.txt")
	subtrain <-read.table("subject_train.txt")
	
Combine Activity and Subject into Test Table

	alltest <- cbind(ytest,xtest)
	alltest <- cbind(subtest,alltest)


Combine Activity and Subject into Train Table

	alltrain <- cbind(ytrain,xtrain)
	alltrain <- cbind(subtrain,alltrain)

Combine Test and Training Tables

	masterset <- rbind(alltest,alltrain)

Add proper column names to the master set
_NOTE:_ This is also part of step 4. We've now added the descriptive column names.
This is important to finish here so that we can extract the correct columns later.

	colnames(masterset) <- c("Subject","Activity", varnames)
	
`Masterset`, with the required columns and new column names, will be 10299 observations of 563 variables.

# Step 2
Extract only the measurements on the mean and standard deviation for each measurement
Assign the master set Column names to a temporary vector, in case we mess up.

	colstrings <- colnames(masterset)
	
Look for the strings "mean" and "std" in the column names and return their indices in separate vectors

	meanvec <- grep("mean", colstrings)
	stdvec <- grep("std", colstrings)

Combine those vectors

	meanstdvec <- c(meanvec, stdvec)
	
Sort the resulting vector for quick human-readability

	sort(meanstdvec)
	
Make the new table with only the subject(col1), activity(col2), mean and standard columns.

	meanstdmaster <- masterset[,c(1,2,meanstdvec)]

# Step 3
Assign descriptive activity names to the activites column
Get a list of the activities into a vector

	actlabels <- read.table("activity_labels.txt")
	actlabels <- actlabels$V2
	
Use the FACTOR function to assign labels and levels to a temporary vector

	activitytext <- factor(meanstdmaster$Activity, levels = c(1:6), labels = (actlabels))
	
Finally, assign the temporary vector to the master data set as the activity column

	meanstdmaster$Activity <- activitytext
	
`meanstdmaster` will now be a data frame of 10299 observations of only 81 variables
	
	
#Step 4
Assign descriptive variable names to the data set
_PLEASE NOTE:_ We did this already in Step 1 when we made the master data set.

#Step 5
Create a separate, tidy data set with the average of each variable for each activity and each subject.

First, using the reshape package, melt the data by subject and Activity

	meltedmaster <- melt(meanstdmaster, id=c("Subject","Activity"))
	
Second, cast the data into a new table by Subject + Activity, writing the MEAN of each variable to the cells

	castmaster <- cast(meltedmaster, Subject + Activity ~ variable, mean)

Write the final, tidy dataset to a file

	write.table(castmaster, "SubjActivityMeans.txt")
	
