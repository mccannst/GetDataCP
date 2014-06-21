# create a data frame

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

