## Set-up the environment
# 1. Set working directory
# Note: It is assumed that the user of this scrpt is currently in the same
# location as the downloaded data files
# my_wd <- getwd() 
# setwd(my_wd)

#2. Load any libraries not in base package
library(dplyr)

## Download the main archived data file and unzip it
# 3. Set-up a variable for the 'Final' zip file
data_file_DS3 <- "Coursera_DS3_Final.zip"
# 4. Set-up a variable for the URL
DS3_Final_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 5. Download the file
download.file(DS3_Final_URL, data_file_DS3, method="curl")
unzip(data_file_DS3)
# Note: the data is actually extracted to a folder called 'UCI HAR Dataset',

## Extract from data file descripton
#- 'README.txt'
#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
#- 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.
#- 'train/y_train.txt': Training labels.
#- 'test/X_test.txt': Test set.
#- 'test/y_test.txt': Test labels.
#The following files are available for the train and test data. Their descriptions are equivalent. 
#- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
#- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
#- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
#- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


# 6. Extract data from the file and put them in a series of data frame variables
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
activity_subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


## Perform the tasks defined in the assignment

## Step 1. Merge the training and the test sets to create one data set
Merged_Subject <- rbind(activity_subject_train, activity_subject_test)
Merged_X <- rbind(x_train, x_test)
Merged_Y <- rbind(y_train, y_test)
Single_Data_Set <- cbind(Merged_Subject, Merged_Y, Merged_X)

## Step 2. Extract only the measurements on the mean and standard deviation 
## for each measurement
Tidied_Data_Set <- Single_Data_Set %>% select(subject, code, contains("mean"), contains("std"))

## Step 3. Use descriptive activity names to name the activities in the data set
Tidied_Data_Set$code <- activities[Tidied_Data_Set$code, 2]

## Step 4. Appropriately label the data set with descriptive variable names
names(Tidied_Data_Set)[2] = "activity"
names(Tidied_Data_Set)<-gsub("Acc", "Accelerometer", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("angle", "Angle", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("BodyBody", "Body", names(Tidied_Data_Set))
# Apply next to all starting with f to catch all varations on Frequency
names(Tidied_Data_Set)<-gsub("^f", "Frequency", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("gravity", "Gravity", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("Gyro", "Gyroscope", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("Mag", "Magnitude", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("^t", "Time", names(Tidied_Data_Set))
names(Tidied_Data_Set)<-gsub("tBody", "TimeBody", names(Tidied_Data_Set))

#Labels requiring a handling of mixed case
# Allow for mixed case
names(Tidied_Data_Set)<-gsub("-freq()", "Frequency", names(Tidied_Data_Set), ignore.case = TRUE)
# Allow for mixed case
names(Tidied_Data_Set)<-gsub("-mean()", "Mean", names(Tidied_Data_Set), ignore.case = TRUE)
# Allow for mixed case
names(Tidied_Data_Set)<-gsub("-std()", "STD", names(Tidied_Data_Set), ignore.case = TRUE)


## Step 5. From the data set in step 4, creates a second, independent tidy 
## data set with the average of each variable for each activity and each subject.
Second_Data_Set <- Tidied_Data_Set %>% group_by(subject, activity) %>% summarise_all(list(mean))
# Write the data frame into a text file, excluding the row names
write.table(Second_Data_Set, "Independent_Tidy_Data_Set.txt", row.name=FALSE)
