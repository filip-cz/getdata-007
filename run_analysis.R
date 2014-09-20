#read test files
activity_labels <- read.table("./getting_cleaning_data/Data/activity_labels.txt")
features <- read.table("./getting_cleaning_data/Data/features.txt")

subject_test <- read.table("./getting_cleaning_data/Data/test/subject_test.txt")
X_test <- read.table("./getting_cleaning_data/Data/test/X_test.txt")
y_test <- read.table("./getting_cleaning_data/Data/test/y_test.txt")

subject_train <- read.table("./getting_cleaning_data/Data/train/subject_train.txt")
X_train <- read.table("./getting_cleaning_data/Data/train/X_train.txt")
y_train <- read.table("./getting_cleaning_data/Data/train/y_train.txt")

#merge data
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)

#select and name features
selected_features <- grepl("mean|std", features[,2])
names(X) <- features[,2]
X <- X[,selected_features]

y[,2] <- activity_labels[y[,1],2]
names(y) <- c("Activity_ID", "Activity_Label")
names(subject) <- "subject"

#bind data
data <- cbind(subject, y, X)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)

require("reshape")
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# SECOND DATA SET
tdata = cast(melt_data, subject + Activity_Label ~ variable, mean)

# EXPORT
write.table(tdata, file = "./tdata.txt", row.name=FALSE)
