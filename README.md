GCDataAssignment
================

Assignment files for Coursera course "Getting and Cleaning Data"

## Working with [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The dataset is geared toward a machine learning exercise, splitting the
collected data into two separate datasets for training and testing. As the
dataset is further broken out into separate files isolating the observed subject
and the observed acivity from the data collected, it is necessary to consolidate
the individual files into a dataset, then combine the testing and training data
into a single dataset for aggregation.

The course instructor has assigned us to do the above merge and then perform the
aggregation only on the fields pertaining to mean and standard deviations of the
observed data. The subset of fields from the original dataset are identified in
the [code book](CODEBOOK.md).

## Assignment Details and the steps of the run_analysis.R script
Create one R script called run_analysis.R that does the following. 
0. Retrieve the dataset if necessary.
   First the script checks for the availability of the dataset. If it is not
   present, the script will download and extract the dataset.

1. Merges the training and the test sets to create one data set.

   As the dataset does not contain variable names, but provides a features.txt
   file that contains the variable names in the order the columns appear in the
   dataset, the script reads in the file, and as it reads in the x_test and 
   x_train data files, it uses the features as column names. 
   Activity files are also imported and combined from Y_test.txt and Y_train.txt
   Subject files are also imported and combined from subject_test.txt and
   subject_train.txt.
   Note that when combining all_data, activities, and subjects, it is vital that
   the same order is used (test, then train) in order to correlate the subject
   and activity with the observed data.

2. Extracts only the measurements on the mean and standard deviation for each
   measurement. 
   The script assembles a list of column names where the label for a column
   contains the text "mean" or "std", this is then used in step 5 to create
   a tidy data set.

3. Uses descriptive activity names to name the activities in the data set
   The original data set provides a file containing the activity descriptions
   that correspond to the ids representing the activity in the Y_train.txt and
   Y_test.txt files. The labeled_activities data frame is created using this
   mapping from the id to the String representation.

4. Appropriately labels the data set with descriptive variable names. 
   The script modifies the original labels, taken from the features.txt file,
   to create column names that are a bit more meaningful. Based on the original
   documentation of the data set, the script prefixes variables that start with
   "t" to "Time", "f" to "Frequency", "Acc" is expanded to "Accel", and in order
   to preserve the "CamelCasing" of the variable names, the script also
   capitalizes the "mean" and "std" substrings.

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
   The script leverages the reshape2 library to obtain a "molten" data set with
   only the appropriate columns, using the cols list as described in #2 above.
   When the molten dataset is recast, the mean function is used to identify the
   average of the values for each of the desired columns.

Since the script created a data frame containing the original labels as well as
the new label, the script is able to use that data frame to dynamically create
the CODEBOOK.md file.

