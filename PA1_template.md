# Reproducible Research: Peer Assessment 1
Rich Morrison  
May 16, 2016  


## Loading and preprocessing the data

Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) [52K]  
Load the dataset, unzip and create a data.frame in R.


```r
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", temp)
dat <- read.csv(unzip(temp, "activity.csv"), header=TRUE, sep=",")
unlink(temp)
```

## What is mean total number of steps taken per day?

Calculate the total number steps taken on each day. Display a histogram of total number steps taken per day.

```r
tot_steps_per_day <- aggregate(steps ~ date, dat, sum)
hist(tot_steps_per_day$steps, 
     main="Histogram Total Steps per Day",
     col="lightblue", 
     xlab="Total Steps Taken on a Day", 
     ylab="Frequency of Days",
     breaks=10
    )
```

![](PA1_template_files/figure-html/totalstepsperday-1.png)

Calculate the mean and median of the total number of steps taken per day and display a boxplot of the total steps per day shown.


```r
mean_tot_steps <- mean(tot_steps_per_day$steps)
median_tot_steps <- median(tot_steps_per_day$steps)
par(mar=c(1,4,3,4))
boxplot(tot_steps_per_day$steps,
        main="Boxplot of Total Steps Per Day",
        ylab="Total Steps per Day"
        )
abline(h=mean_tot_steps,col="blue")
```

![](PA1_template_files/figure-html/meanmedian-1.png)

The *__mean total steps per day__* is **10766.19** shown by the blue line and the *__median total steps per day__* is **10765** shown by the bold black line.

## What is the average daily activity pattern?

Display a time series plot of the 5-minute interval (from 0 through 2355) and the average number of steps taken during that 5-minute interval over the dataset.


```r
int_mean <- aggregate(steps ~ interval, dat, mean, na.rm=TRUE)
plot(int_mean$interval, 
     int_mean$steps, 
     type="l", 
     col="blue", 
     main="Average Number Steps Taken per 5-Minute Interval",
     xlab="5-Minute Interval",
     ylab="Average Number of Steps Taken")
```

![](PA1_template_files/figure-html/intervalaverage-1.png)

Find the 5-minute interval across all days in the interval with the maximum average number of steps.


```r
max_int_mean <- int_mean$interval[which.max(int_mean$steps)]
```

The 5-minute interval at **835** has the maximum average number of steps taken of **206.17**.

## Imputing missing values
The presence of missing data may introduce bias into some of the calculations or summaries of data.  The missing data is found by:


```r
tot_missing <- sum(is.na(dat$steps))
percent_missing <- sum(is.na(dat$steps)*100/nrow(dat))
```

There are **2304** intervals with missing data (labled as 'NA' in the data set).  This represents **13.11%** of the observations in the dataset. A closer look at the missing values show that there are 8 calendar days worth of data missing such that each unique interval value has 8 missing observations for the number of steps taken.  


```r
# show number of unique values in a table of number NA values
# for each interval
unique(table(dat$interval[is.na(dat$steps)]))
```

```
## [1] 8
```
#### Impute mean number of steps for each missing interval
The strategy used to impute the missing data is to set to the mean number of steps for that 5-minute interval. A new dataset is created below with the missing data filled in followed by another histogram and calculated mean and meadian.


```r
# create an updated data set filling NA values with the mean step 
# values for the same interval in the original dataset
dat2 <- dat
dat2$steps[is.na(dat$steps)] <- int_mean$steps[match(dat2$interval[is.na(dat$steps)], int_mean$interval)]

# calculate the total, mean and median steps using the updated data 
tot_steps_per_day2 <- aggregate(steps ~ date, dat2, sum)
mean_tot_steps2 <- mean(tot_steps_per_day2$steps,na.rm=TRUE)
median_tot_steps2 <- median(tot_steps_per_day2$steps,na.rm=TRUE)
```

The updated **_mean_** total steps per day is **10766.19** and the updated *__median__* total steps per day is **10766.19**. Because of the method used to impute the data, the mean does not change, but the median is slightly higher. The updated dataset histogram is shown below and is different due to the higher count of observations.


```r
hist(tot_steps_per_day2$steps, 
     main="Histogram Total Steps per Day - Imputed Data Set",
     col="lightblue", 
     xlab="Total Steps Taken on a Day", 
     ylab="Frequency of Days",
     breaks=10
    )
```

![](PA1_template_files/figure-html/histogramupdated-1.png)

## Are there differences in activity patterns between weekdays and weekends?

Start by changing the 'date' variable from a factor to date value.  Then determine the day of week to label the new factor 'weekday' with 2 levels (weekday or weekend).


```r
dat2$date <- as.Date(dat2$date)
dat2$weekday <- as.factor(weekdays(dat2$date))
levels(dat2$weekday) <- list(weekday=c("Monday",
                                       "Tuesday",
                                       "Wednesday",
                                       "Thursday",
                                       "Friday"),
                             weekend=c("Saturday",
                                       "Sunday")
                             )
```

Next determine the interval mean number of steps for weekday days and weekend days using the new factor variable.  Plot the results.


```r
intervals_mean2 <- aggregate(steps ~ interval + weekday, dat2, mean)

# plot the two time series
library("lattice")
xyplot(steps ~ interval | weekday, 
       data=intervals_mean2, 
       type="l", 
       col.line="blue",
       layout=c(1,2),
       xlab="5-Minute Time Interval",
       ylab="Average Number Steps"
       )
```

![](PA1_template_files/figure-html/activitypatterns-1.png)


Overall, it appears this subject is somewhat more active with more steps during an average weekend day compared to a weekday.  

```r
# find total mean steps for weekend days and weekday days
aggregate(steps ~ weekday, intervals_mean2, sum)
```

```
##   weekday    steps
## 1 weekday 10255.85
## 2 weekend 12201.52
```
