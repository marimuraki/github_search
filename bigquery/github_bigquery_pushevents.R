require(ggplot2)
require(scales)

setwd("~/Dropbox/GA/project/bigquery")

# data pulled from githubarchive
pushevents_stats  <- read.csv("pushevents_stats_2013.csv")
pushevents_ymd    <- read.csv("pushevents_by_yearmonthday.csv") 
pushevents_ymd    <- subset(pushevents_ymd, year==2012 | year== 2013)

# aggregate across languages
pushevents_ymd_total  <- aggregate(pushes_by_lang ~ year + month + day, 
                                 data=pushevents_ymd, FUN=sum)
pushevents_yd_total   <- aggregate(pushes_by_lang ~ year + day, 
                                  data=pushevents_ymd, FUN=sum)
pushevents_ym_total   <- aggregate(pushes_by_lang ~ year + month, 
                                   data=pushevents_ymd, FUN=sum)

pushevents_ymd_total$yearnum  = as.numeric(as.character(pushevents_ymd_total$year))
pushevents_ymd_total$monthnum = as.numeric(as.character(pushevents_ymd_total$month))
pushevents_ymd_total$daynum   = as.numeric(as.character(pushevents_ymd_total$day))
pushevents_ymd_total$monthday = pushevents_ymd_total$monthnum*10+pushevents_ymd_total$daynum

# graph total counts by year-month-day
ggplot(pushevents_ymd_total, aes(day,pushes_by_lang,group=month,colour=month)) + 
  geom_point() +
  geom_line() +
  facet_grid(year ~ .) +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Month-Day of Week") +
  scale_y_continuous(labels=comma) + 
  scale_x_discrete(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Month", 
                        breaks=c(1:12), 
                        labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

png('github_bigquery_pushevents_total_ymd.png')
ggplot(pushevents_ymd_total, aes(monthday,pushes_by_lang,group=month,colour=month)) + 
  geom_point() +
  geom_line() +
  facet_grid(year ~ .) +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Month-Day of Week") +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(breaks=c(11:17,21:27,31:37,41:47,51:57,61:67,71:77,81:87,91:97,101:107,111:117,121:127),
                     labels=c("S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S")) + 
  scale_colour_discrete(name="Month", 
                        breaks=(1:12),
                        labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
dev.off()

png('github_bigquery_pushevents_total2013_ymd.png')
ggplot(subset(pushevents_ymd_total,year==2013), aes(monthday,pushes_by_lang,group=month,colour=month)) + 
  geom_point() +
  geom_line() +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Total Push Events by Month-Day of Week (2013)") +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(breaks=c(11:17,21:27,31:37,41:47,51:57,61:67,71:77,81:87,91:97,101:107,111:117,121:127),
                     labels=c("S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S",
                              "S","M","T","W","T","F","S")) + 
  scale_colour_discrete(name="Month", 
                        breaks=(1:12),
                        labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
dev.off()

tapply(pushevents_ymd_total$pushes_by_lang, pushevents_ymd_total$day, summary)
fit <- lm(pushes_by_lang ~ as.factor(day), data=pushevents_ymd_total)
summary(fit)
coefficients(fit)

# graph total counts by year-month
  # shows growth over time, not necessarily "hot" months
  # jump in Sep-Oct ~ school start?
  # drop in May-Jun ~ summer break?
ggplot(subset(pushevents_ym_total,year==2013), aes(month,pushes_by_lang)) + 
  geom_point() +
  xlab("Month") +
  ylab("Total") + 
  ggtitle("Total Push Events by Month") +
  scale_y_continuous(labels=comma) + 
  scale_x_discrete(breaks=1:12,
                     labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) 

# graph total counts by year-day
png('github_bigquery_pushevents_total_yd.png')
ggplot(pushevents_yd_total, aes(as.numeric(day),pushes_by_lang,group=as.character(year),colour=as.character(year))) + 
  geom_point() +
  geom_line() +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Day of Week") +
  scale_y_continuous(labels=comma) + 
  scale_x_discrete(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Year")
dev.off()

# graph average daily counts by day of week
# define errorbars
limits <- aes(ymax=max,ymin=min)
ggplot(pushevents_stats, aes(day,avg)) + 
  geom_point() +
  geom_line() +
  xlab("Day of Week") +
  ylab("Average") + 
  ggtitle("Average Daily Push Events by Day of Week") +
  scale_y_continuous(labels=comma) + 
  scale_x_discrete(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Year") 

