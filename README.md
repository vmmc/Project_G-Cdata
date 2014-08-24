==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been aggregated into a dataset with means of data only.

#I proceed to explain the transformations I've done to the data:

## Remember to set your own working directory
```{r, echo=FALSE}
setwd("UCI HAR Dataset") 
```

## Loading all the files to use
```{r, echo=FALSE}
features        <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

subject_train   <- read.table("./train/subject_train.txt")
X_train         <- read.table("./train/X_train.txt")
y_train         <- read.table("./train/y_train.txt")

subject_test    <- read.table("./test/subject_test.txt")
X_test          <- read.table("./test/X_test.txt")
y_test          <- read.table("./test/y_test.txt")
```

## Merge test and train sets
```{r, echo=FALSE}
subject         <- rbind(subject_train, subject_test)
X               <- rbind(X_train, X_test)
y               <- rbind(y_train, y_test)
```

## Assign the features to the column names
```{r, echo=FALSE}
colnames(X) <- features[,2]
```

## Keep only the variables with "mean" or "std" on them
```{r, echo=FALSE}
X <- X[, grep("mean|std", colnames(X))]
```

## Making the column names tidier
```{r, echo=FALSE}
colnames(X) <- gsub("()", "", colnames(X), fixed=TRUE)
colnames(X) <- gsub("-", "_", colnames(X), fixed=TRUE)
```

## Using descriptive activity names by changing it to a factor
```{r, echo=FALSE}
y$V1 <- as.factor(y$V1)
attributes(y$V1)$levels <- as.character(activity_labels$V2)
```

## Convert the subjects to a factor because it's more representative
```{r, echo=FALSE}
subject$V1 <- as.factor(subject$V1)
```

## Combining everything into one data set
```{r, echo=FALSE}
DF <- cbind(subject=subject$V1, activity=y$V1, X)
```

## Tidy data set with the average of each variable for each activity and each subject
## It has 180 rows, one for each subject(30) and activity(6): 30*6=180
## and each column is the average of each feature (79 columns)
```{r, echo=FALSE}
tidyDF <- sapply(split(X, list(DF$subject,DF$activity)), colMeans)
tidyDF <- as.data.frame(t(tidyDF))
```

## Save the tidy data set to a file
```{r, echo=FALSE}
write.table(tidyDF, file="tidyData.txt", row.names=FALSE)
```