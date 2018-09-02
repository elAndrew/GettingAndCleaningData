###Getting and Cleaning Data Course Project###
##############################################


#################################################
#Let's start by finding just the mean and standard deviation variables 
#in the features.txt file.  We will also get the length, as this will 
#be our number of columns (variables) in the data.

features <- read.table("features.txt")[,2]
nvars <- length(features)
varnames <- grep("mean\\(\\)|std\\(\\)", features, value=TRUE, ignore.case = TRUE)
#There are 66 features that meet this critera.  
#We are taking a narrow view and not including meanFreq() 
#and things like angles that incorporate graivityMean into our selection.  
#Only mean() and std() features are included.
filter <- grepl("mean\\(\\)|std\\(\\)", features)
##################################################


##################################################
#Read in X_test.txt and X_train.txt:

library(dplyr)

x_train <- scan("X_train.txt")
nobs <- length(x_train) / nvars

x_train <- 
  x_train %>%  
  as.vector() %>%
  matrix(nrow=nobs, ncol=nvars) %>%
  as.data.frame.matrix()

x_test <- scan("X_test.txt")
nobs <- length(x_test) / nvars

x_test <- 
  x_test %>%  
  as.vector() %>%
  matrix(nrow=nobs, ncol=nvars) %>%
  as.data.frame.matrix()
##################################################


##################################################
#Use our filter (from above) and apply the variable names from features object:

x_train <- x_train[,filter]
names(x_train) <- varnames

x_test <- x_test[,filter]
names(x_test) <- varnames
#this accomplishes point 2 of the assignment - 
#extract only mean and standard deviation measurements
#it also accomplishes point 4 of the assignment - 
#appropriately lables data set with desicriptive variable names
##################################################


##################################################
#Now we have two more columns to add to each of our dataframes - 
#activity, and subject ID.  
#Let's start with the activity, from y_train.txt and y_test.txt:

activity <- scan("y_train.txt")
x_train <- cbind(activity, x_train)

activity <- scan("y_test.txt")
x_test <- cbind(activity, x_test)
##################################################


##################################################
#Now we will add the subjectID to each of our dataframes from the 
#subject_train.txt and subject_test.txt files:

subjectID <- scan("subject_train.txt")
x_train <- cbind(subjectID, x_train)

subjectID <- scan("subject_test.txt")
x_test <- cbind(subjectID, x_test)
#this further accomplishes point 4 of the assignment - 
#appropriately lables data set with desicriptive variable names
##################################################


##################################################
#Now we can simply combine our datasets:

combinedData <- rbind(x_train, x_test)
#this accomplishes point 1 of the assignement - 
#merges the training and test data sets
##################################################


##################################################
#Now we need to alter the activity variable values for calrity, 
#using the activity_labels.txt file:

labels <- read.csv("activity_labels.txt", sep=" ", header = FALSE)

for(i in 1:nrow(labels)){
  combinedData$activity[combinedData$activity == i] <- as.character(labels[i,2])
}
#this accomplishes point 3 of the assignment - 
#uses descriptive activity names to name the activities in the data set
##################################################


##################################################
#One more variable name change.  
#We'll remove/replace some special characters that might make variable 
#names difficult to deal with (remove "()", and replace "-" with "_"):

library(stringr)

names(combinedData) <- names(combinedData) %>%
  str_remove_all("\\(|\\)") %>%
  str_replace_all("-", "_")
##################################################


##################################################
#Finally, we will use our combinedData data set to create a new data set 
#that provides the average of each variable for each activity, and each subject

library(reshape2)
library(plyr)

meltCombinedData <- 
  melt(combinedData,
  id.vars = c(1,2),
  measure.vars = c(3:68))
#this creates a very long data frame, a seperate observation for each feature variable

avgByActivity <- dcast(meltCombinedData, activity ~ variable, mean)
#a data frame that has the average of each feature, for each activity
avgBySubjectID <- dcast(meltCombinedData, subjectID ~ variable, mean)
#a data frame that has the average of each feature, for each subjectID
avgCombinedData <- join(avgByActivity, avgBySubjectID, type="full")
#the two avgerge data frames combined

#the data frame is back to being wide, we will instead make it long by again 
#making each feature a variable option, instead of its own variable column
avgCombinedData <- melt(avgCombinedData,
  id = c(1,68),
  measure.vars = c(2:67))

#and now to rename the variables for clarity:
names(avgCombinedData)[3:4] <- c("feature", "meanValue")

#To confirm that this data frame is correct, in its dimensions, 
#it should have the number of activities 
#(6) x the number of features (66) added to the number of 
#subjectIDs (30) x the number of features (66)
6 * 66 + 30 * 66 == nrow(avgCombinedData) #this is TRUE

write.table(avgCombinedData, "myTidyData.txt", row.names = FALSE, quote = FALSE)
#this accomplishes point 5 of the assignment - 
#myTidyData.txt is a tidy set with the average of each variable for each activity and each subject 
##################################################
