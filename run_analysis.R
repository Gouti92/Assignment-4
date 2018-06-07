#Reading the data
#train
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
#test
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#features
features <- read.table("./UCI HAR Dataset/features.txt")
#activities
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
#End of data reading
#Merging Test and train data
x_total <- rbind(x_test,x_train)
y_total <- rbind(y_test,y_train)
subject_total <- rbind(subject_test,subject_train)
#Selecting only mean and standard deviation from the measured variables
measured_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
x_selected <- x_total[,measured_var[,1]]

colnames(y_total) <- "activity"
y_total$activitytype <- factor(y_total$activity, labels = as.character(activity[,2]))
activity <- y_total[,-1]
colnames(x_selected) <- features[measured_var[,1],2]
colnames(subject_total) <- "subject"

#Merging all the columns
total <- cbind(x_selected, activity,subject_total)

#Summarising
mean_total <- total %>% group_by(activity,subject) %>% summarise_each(funs(mean))

#Writing data
write.table(mean_total,"./UCI HAR Dataset/tidy.txt", row.names = FALSE,col.names = TRUE)
