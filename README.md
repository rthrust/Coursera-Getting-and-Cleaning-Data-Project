# Coursera-Getting-and-Cleaning-Data-Project
## Introduction
This file forms one component of the materials rwequired for the Coursera Getting and Cleaning Data Project, part of the Data Science specialisation offered by Johns Hopkins: https://www.coursera.org/learn/data-cleaning/home/welcome.

It describes the files contained in this repository (https://github.com/rthrust/Coursera-Getting-and-Cleaning-Data-Project), the referenced source data, and explains their usage. 

## Objectives
Extracted from: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project and adpated for the purposes of this file:

You should create one R script called run_analysis.R that does the following:
1. Merges the training and the test sets [from the Source Data; see below] to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Files in this repository
### run_analysis.R 
-> An R script that carries out the five data cleaning and tidying tasks defined in the objectives above. It requires intstallation and use of the dplayr library,

### Independent_Tidy_Data_Set.txt
-> The resulting data set from executing the run_analysis.R script, therby fulfilling step 5 under the Objectives listed above

### Code_Book.md
-> This doucment describes:
- data sources used
- variables created
- functions and transformations employed to obtain and 'clean' the data
    
### README.md
-> This file; see 'Introduction' section above    

## Source Data Set
### Full description of the data from the site where the data was obtained
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### Data file
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
