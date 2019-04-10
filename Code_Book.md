# Code Book
## Introduction

run_analysis.R performs the following tasks, as outlined in the course project instructions available at: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project, and adpated for the purposes of this file:

    1. Merge the training and the test sets [from the Source Data; see below] to create one data set.
    2. Extract only the measurements on the mean and standard deviation for each measurement.
    3. Use descriptive activity names to name the activities in the data set
    4. Appropriately label the data set with descriptive variable names.
    5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
    
    Please see README.md in this repository for further background information: https://github.com/rthrust/Coursera-Getting-and-Cleaning-Data-Project/blob/master/README.md

## Code Description
### Note
In-code comments are also available in the run_analysis.R script

### Prerequistes
Install the dplyr package (https://www.rdocumentation.org/packages/dplyr/versions/0.7.8)

### Set-up the Environment
Load the dplyr library using library()
Functions from this library are required later 

### Download and extract the file for the data set
Create variables for the URL containing the path to the data set file and the data set file name
Feed these variables into download.file() to download the file (note: I assume that there is no existing file, so re-running the script will overwrite files wth the same name).

Unzip/extract the file in the current working directory -> This creates a new directory called 'UCI HAR Dataset'
 
#### Note about data files
Baed on the data file descripton, one knows the following infrmation about the files in 'UCI HAR Dataset' directory
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

See also features_info.txt which is created in the 'UCI HAR Dataset' directory. Extract of first prargraphs providing more context to the features.txt file, so it may be understood what is in the second column of this file:
'The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.'

### Write required data into data frame variables as a preparation for merging in a later step

Data is extracted from file in form of a data frame using read.table()

A line-by-line breakdown is provided below:

Format:
#### Line of code
Description of data in file/data frame 
Properties of file (dimensions)

#### activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
This dataframe links class labels (column is labelled "code" in the file) with activity names
Dimensions: 2 columns and 6 rows

#### features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
List of all features. features_info.text explains that these features, contained in the second column of this table, come from the accelerometer and gyroscope 3-axial raw signals. The first column is the reference of kex in this case.
Dimensions: 2 columns and 561 rows

#### activity_subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
Lists the subjects who performed each activity (test set)
Dimensions: 1 column and 2947 rows

#### x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
Contains the Test Set
Dimensions: 1 column and 2947 rows

#### y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
Lists the Test labels
Dimensions: 1 columns and 2947 rows

#### activity_subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Lists the subject who performed the activity for each window sample. Range is stated to be between 1 and 30, but in this case is 21 unique subjects, as shown by using a rather 'quick and dirty'  unique(as.matrix(activity_subject_train))
Dimensions: 1 column and 7352 rows

#### x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
Contains the Training set recorded features
Dimensions: 561 columns and 7532 rows

#### y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
Lists the Training Labels code labels
Dimensions: 1 columns and 7532 rows

### Task 1: Merge the training and the test sets (from the Source Data; see below) to create one data set       
Here, the rbind() function is used to join the dataframes by row:

#### Merged_Subject <- rbind(activity_subject_train, activity_subject_test)
the subjects who performed the activitys for the Training Set and Test Set: Merged_Subject
Dimensions: 1 columns and 10299 rows

#### Merged_X <- rbind(x_train, x_test)
the Training Set and Test Set into a new data frame: Merged_X
Dimensions: 561 columns and 10299 rows

#### Merged_Y <- rbind(y_train, y_test)
the Training Labels and Test Labels into a new data frame: Merged Y
Dimensions: 1 column and 10299 rows

Now cbind is used, as the intention is to join columns:
#### Single_Data_Set <- cbind(Merged_Subject, Merged_Y, Merged_X)
Finally, merge all three sets into one: Single_Data_Set
Dimensions: 563 columns and 10299 rows

### Task 2: Extract only the measurements on the mean and standard deviation for each measurement

#### Tidied_Data_Set <- Single_Data_Set %>% select(subject, code, contains("mean"), contains("std"))
Here, select is used to take just the data for the mean and standard deviation columns from the Single_Data_Set table (see Task 1 above), as well as the corresponding subject and code. This is then stored in a new data frame, unimaginatively titled 'Tidied Data Set'.
Notably, the data set is now much leaner, but happily the same length!
Dimensions: 88 columns and 10299 rows

### Task 3: Use descriptive activity names to name the activities in the data set
#### Tidied_Data_Set$code <- activities[Tidied_Data_Set$code, 2]
As stated above, codes are linked with the respective activity description in the activity_labels.txt file (which in turn was output to the activities data frame variable, e.g.

code      activity
1         WALKING
2         WALKING_UPSTAIRS
3         WALKING_DOWNSTAIRS
4         SITTING
5         STANDING
6         LAYING
 
On this basis, the 'code' in Tidied_Data_Set is provided with the name of the corresponding 'activity' from column two and written back into Tidied_Data_Set.
        
### Task 4: Appropriately label the data set with descriptive variable names
Here, gsub is used to swap abbreviations and variations on abbreviations with the full decription, features_info.text maybe used as a reference for selection of full descriptions. 
#### names(Tidied_Data_Set)[2] = "activity"
From Task 3, it is known that column 2 should be called activity (see above)
#### names(Tidied_Data_Set)<-gsub("Acc", "Accelerometer", names(Tidied_Data_Set))
From features_info.text/features.txt/data files it is known that Accelorometer is abbreviated to Acc
#### names(Tidied_Data_Set)<-gsub("angle", "Angle", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("BodyBody", "Body", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("^f", "Frequency", names(Tidied_Data_Set))
Apply to all cases starting with f to catch all varations on Frequency
#### names(Tidied_Data_Set)<-gsub("gravity", "Gravity", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("Gyro", "Gyroscope", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("Mag", "Magnitude", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("^t", "Time", names(Tidied_Data_Set))
#### names(Tidied_Data_Set)<-gsub("tBody", "TimeBody", names(Tidied_Data_Set))

Labels requiring a handling of mixed case, use consistent case (capitalisation)
#### names(Tidied_Data_Set)<-gsub("-freq()", "Frequency", names(Tidied_Data_Set), ignore.case = TRUE)
Allow for mixed case
#### names(Tidied_Data_Set)<-gsub("-mean()", "Mean", names(Tidied_Data_Set), ignore.case = TRUE)
Allow for mixed case
#### names(Tidied_Data_Set)<-gsub("-std()", "STD", names(Tidied_Data_Set), ignore.case = TRUE)
Allow for mixed case

### Task 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.data set with the average of each variable for each activity and each subject.

#### Second_Data_Set <- Tidied_Data_Set %>% group_by(subject, activity) %>% summarise_all(list(mean))
The function group_by is used to group the data in Tidied_Data_Set by subject, then activity. Then summarise_all is applied to this grouped data, using the list(mean) function to take the average (arithmetic mean in this case) for each activity.
Dimensions: 88 columns and 180 rows.

#### write.table(Second_Data_Set, "Independent_Tidy_Data_Set.txt", row.name=FALSE)
Write the Second_Data_Set data frame into a text file 'Independent_Tidy_Data_Set.txt, excluding the row names. 


