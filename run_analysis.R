# Read txt file from the working directory
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    
X_test  <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test  <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
    
# Merges the training and the test sets to create one data set.
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

# Extracts the mean and standard deviation for each measurement
mead_st_index <- c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,
                   253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543)
rawdata <- cbind(subject,y,X[,mead_st_index])

# Uses descriptive activity names to name the activities in the data set
names(rawdata) <- c("volunteer","activity",as.character(features$V2)[mead_st_index])
rawdata$volunteer <- factor(rawdata$volunteer)
rawdata$activity  <- factor(rawdata$activity,labels=c("walking","walking_upstair","walking_downstair",
                                                      "sitting","standing","laying"))

# Creates a tidy data set with the average of each variable for each activity and each subject
tinydata <- as.data.frame(matrix(NA,nrow=180,ncol=length(rawdata)))
splitdata <- split(rawdata,f=list(rawdata$volunteer,rawdata$activity))
for(i in 1:180)
{
    tinydata[i,1:2] <- splitdata[[i]][1,1:2]
    tinydata[i,c(3:length(rawdata))] <- sapply(splitdata[[i]][,c(3:length(rawdata))],mean)
}

names(tinydata) <- c("volunteer","activity",as.character(features$V2)[mead_st_index])
tinydata$volunteer <- factor(tinydata$volunteer)
tinydata$activity  <- factor(tinydata$activity,labels=c("walking","walking_upstair","walking_downstair",
                                                        "sitting","standing","laying"))

# Output the tidy data set as the csv format
write.table(tinydata,"tinydata.csv",sep=",",row.names=FALSE)