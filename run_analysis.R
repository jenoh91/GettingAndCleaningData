        #Merge the training and the test sets to create one data set

#unzip 
unzip("getdata.zip")

#Test Data Set
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Train Data Set
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Merge all Data sets
X <- rbind(x_test, x_train)
Y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)


#Extract only the measurements on the mean and standard deviation for each measurement

#read features
features <- read.table("UCI HAR Dataset/features.txt")

#getting indices for mean and std
index <- grep("mean\\(\\)|std\\(\\)", features[,2])

X <- X[,index]

#Use descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
Y[,1] <- activities[Y[,1],2]

#Appropriately labels the data set with descriptive variable names
names(subject) <- "Activity"
single_dataset <- cbind(X, Y, subject)

names(single_dataset) <- make.names(names(single_dataset))
names(single_dataset) <- gsub('Acc',"Acceleration",names(single_dataset))
names(single_dataset) <- gsub('GyroJerk',"AngularAcceleration",names(single_dataset))
names(single_dataset) <- gsub('Gyro',"AngularSpeed",names(single_dataset))
names(single_dataset) <- gsub('Mag',"Magnitude",names(single_dataset))
names(single_dataset) <- gsub('^t',"TimeDomain.",names(single_dataset))
names(single_dataset) <- gsub('^f',"FrequencyDomain.",names(single_dataset))
names(single_dataset) <- gsub('\\.mean',".Mean",names(single_dataset))
names(single_dataset) <- gsub('\\.std',".StandardDeviation",names(single_dataset))
names(single_dataset) <- gsub('Freq\\.',"Frequency.",names(single_dataset))
names(single_dataset) <- gsub('Freq$',"Frequency",names(single_dataset))

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject
single_dataset <- data.table(single_dataset)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity']
