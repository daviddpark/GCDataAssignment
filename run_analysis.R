# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
library(reshape2)
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_zipfile <- "uci_har_data.zip"
if (!file.exists("data")) {
  dir.create("data")
}

setwd("./data")

if (!file.exists(data_zipfile)) {
  download.file(data_url, destfile=data_zipfile, method="curl")
  unzip(data_zipfile)
}
setwd("./UCI HAR Dataset")

# Merges the training and the test sets to create one data set.
# Appropriately labels the data set with descriptive variable names.
# column names in the X data sets correspond to the labels in features.txt
features <- read.table("features.txt", header=FALSE, stringsAsFactors=FALSE)
# Function to clean the labels up
cleanLabel <- function(label) {
    result <- paste("Average", sub("^t", "Time", label))
    result <- sub("^f", "Frequency", result)
    result <- sub("\\(", "", result, perl=T)
    result <- sub("\\)", "", result, perl=T)
    result <- gsub(",", "", result)
    result <- gsub("-", "", result)
    result <- sub("Acc", "Accel", result)
    result <- sub("mean", "Mean", result)
    result <- sub("std", "Std", result)
    return(result)
}
features$newLabel <- labels <- lapply(features[,2], cleanLabel)

# Load the test data
x_test <- read.table("test/X_test.txt", col.names=labels) # actual data
y_test <- read.table("test/Y_test.txt", col.names=c("ACTIVITY")) # activity id
s_test <- read.table("test/subject_test.txt", col.names=c("SUBJECT")) # subject id

# Load the training data
x_train <- read.table("train/X_train.txt", col.names=labels) # actual data
y_train <- read.table("train/Y_train.txt", col.names=c("ACTIVITY")) # activity id
s_train <- read.table("train/subject_train.txt", col.names=c("SUBJECT")) # subject id

# Combine the appropriate test/train sets together
all_data   <- rbind(x_test,x_train)
activities <- rbind(y_test,y_train)
subjects   <- rbind(s_test,s_train) # 


# Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt", header=FALSE)

# Apply an anonymous function that looks up the label by the activity id from
# the activity_labels data set.
labeled_activities <- as.data.frame(sapply(activities, function(x) activity_labels[x,2]))

# Consolidate the datasets, as the records correspond.
combined <- cbind(subjects, labeled_activities, all_data)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
cols <- c()

for (label in colnames(combined)) {
    if (length(i<-grep("(Mean|Std)", label, ignore.case=TRUE))) {
        cols <- c(label, cols)
    }
}

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
melted <- melt(combined, id=c("SUBJECT","ACTIVITY"), measure.vars=rev(cols))
tidy <- dcast(melted, SUBJECT + ACTIVITY ~ variable, mean)

# Write the dataset out to a file
setwd("../..")
write.table(tidy, file="IMU_data_tidy.txt", row.names=F)

# Create the CODEBOOK.md file
lines <- c("IMU DataSet Codebook","====================","")
lines <- c(lines, "# SUBJECT","Integer identifying subject under observation.")
lines <- c(lines, "")
lines <- c(lines, "# ACTIVITY","String identifying activity under observation.")
lines <- c(lines, "")
for(label in labels) {
    origLabel <- features[which(features$newLabel==label),]["V2"]
    msg <- paste("Average of the original data set's ",
               origLabel, " values.")
    lines <- c(lines, paste("# ",label))
    lines <- c(lines, msg)
    lines <- c(lines, " * Numeric value between -1 and 1")
    lines <- c(lines, "")
}
fileConn<-file("CODEBOOK.md")
writeLines(lines, fileConn)
close(fileConn)
