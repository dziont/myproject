
# read the data sets

t.labels <- read.table("test/y_test.txt", col.names="label")
t.subjects <- read.table("test/subject_test.txt", col.names="subject")
t.data <- read.table("test/X_test.txt")
n.labels <- read.table("train/y_train.txt", col.names="label")
n.subjects <- read.table("train/subject_train.txt", col.names="subject")
n.data <- read.table("train/X_train.txt")

# merge datasets in the format of: subjects, labels, everything else

data <- rbind(cbind(t.subjects, t.labels, t.data),
              cbind(n.subjects, n.labels, n.data))


# read the features

features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# only retain features of mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# select only the means and standard deviations from data
# increment by 2 because data has subjects and labels in the beginning
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


# read the labels (activities)

labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]


# first make a list of the current column names and feature names

good.colnames <- c("subject", "label", features.mean.std$V2)
# then remove every non-alphabetic character and converting to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(data.mean.std) <- good.colnames


# find the mean for each combination of subject and label

aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)


# write the data for course upload

write.table(format(aggr.data, scientific=T), "neat.txt",
            row.names=F, col.names=F, quote=2)
