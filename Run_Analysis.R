library(dplyr)
setwd(choose.dir())

labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_train_activities <- read.table("UCI HAR Dataset/train/y_train.txt")
train_Sub <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test_activities <- read.table("UCI HAR Dataset/test/y_test.txt")
test_Subj <- read.table("UCI HAR Dataset/test/subject_test.txt")


names(x_train)<-features[,2]
names(x_test)<-features[,2]

names(train_Sub) <-"Subject"
names(x_train_activities)<-"Activity"

names(test_Subj) <-"Subject"
names(y_test_activities)<-"Activity"

x_train_data<-cbind(train_Sub,x_train_activities,x_train)

x_test_data<-cbind(test_Subj,y_test_activities,x_test)

data<-rbind(x_train_data,x_test_data)

data1<-data

features_reqd<-features[grep(".*mean.*|.*std.*", features[,2]),2]

data <- data[, features_reqd]

data$Subject<-data1$Subject
data$Activity<-data1$Activity

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))


data$Activity<-labels[match(data$Activity, labels$V1),2]

data2<-data

# group by subject and activity and summarise using mean
ActivityMean <- data2 %>% 
    group_by(Subject, Activity) %>%
    summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(ActivityMean, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)


