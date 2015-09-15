#The purpose of this project is to demonstrate your ability to collect, work with, and clean a
#data set. The goal is to prepare tidy data that can be used for later analysis. 
#You will be graded by your peers on a series of yes/no questions related to the project. 
#You will be required to submit: 1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and 
#3) a code book that describes the variables, the data, and any transformations or work that
#you performed to clean up the data called CodeBook.md. You should also include a README.md 
#in the repo with your scripts. This repo explains how all of the scripts work and how they 
#are connected.  
#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
#A full description is available at the site where the data was obtained: 

#plyr: Tools for Splitting, Applying and Combining Data
library(plyr)
library(reshape2)


x_train <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
#View(x_train)
y_train <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, y_train, x_train)

x_test <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
#View(x_test)
y_test <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, x_test)

# merge the dataset

#Answer For STEP 1
fullData <- rbind(train, test)

#Add Lables to the table.
features <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
colnames(fullData) <- c("subject", "activity",features[,2])


# Answer for STEP 2
#mean_and_std_features <- grep("(mean|std)\\(\\)", features[, 2])
#meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
Extractedfeatures <- grep(".*mean().*|.*std().*", colnames(fullData))
ExtractedData <- fullData[, c(fullData$subject,fullData$activity, Extractedfeatures)]

#If we want to do some more chages in the column names like we want to write Mean and Std rather than writing mean and std
# on the other way we want to dele () sign form the column names
names(ExtractedData) <- gsub('-mean', 'Mean', names(ExtractedData))
names(ExtractedData) <- gsub('-std', 'Std', names(ExtractedData))
names(ExtractedData) <- gsub('[()-]', '', names(ExtractedData))
#View(ExtractedData)

#Answer for STEP 3

activity_labels <- read.table("D:/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
ExtractedData$activity <- factor(ExtractedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#fullData$activity <- activity_labels[fullData[, 2], 2]

#STEP 4 is is already over in the previous stpes only

#STEP 5
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
#activity and each subject.



ddply(.data=ExtractedData, .variables=c("subject","activity"))
#a <- ddply(fullData, .(subject, activity), )


allData.melted <- melt(ExtractedData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
