setwd("UCI HAR Dataset") # Set your own working directory

# Load all the files to use
features        <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

subject_train   <- read.table("./train/subject_train.txt")
X_train         <- read.table("./train/X_train.txt")
y_train         <- read.table("./train/y_train.txt")

subject_test    <- read.table("./test/subject_test.txt")
X_test          <- read.table("./test/X_test.txt")
y_test          <- read.table("./test/y_test.txt")

# Merge test and train sets
subject         <- rbind(subject_train, subject_test)
X               <- rbind(X_train, X_test)
y               <- rbind(y_train, y_test)

# Assign the features to the column names
colnames(X) <- features[,2]

# Keep only the variables with "mean" or "std" on them 
X <- X[, grep("mean|std", colnames(X))]

# Making the column names tidier
colnames(X) <- gsub("()", "", colnames(X), fixed=TRUE)
colnames(X) <- gsub("-", "_", colnames(X), fixed=TRUE)

# Using descriptive activity names by changing it to a factor
y$V1 <- as.factor(y$V1)
attributes(y$V1)$levels <- as.character(activity_labels$V2)

# Convert the subjects to a factor because it's more representative
subject$V1 <- as.factor(subject$V1)

# Combining everything into one data set
DF <- cbind(subject=subject$V1, activity=y$V1, X)

# Tidy data set with the average of each variable for each activity and each subject
# It has 180 rows, one for each subject(30) and activity(6): 30*6=180
# and each column is the average of each feature (79 columns)
tidyDF <- sapply(split(X, list(DF$subject,DF$activity)), colMeans)
tidyDF <- as.data.frame(t(tidyDF))

# Save the tidy data set to a file
write.table(tidyDF, file="tidyData.txt", row.names=FALSE)

# Remove data that we don't need anymore
rm(subject_train, subject_test, X_train, X_test, y_train, y_test, features, activity_labels, subject, y, X)
