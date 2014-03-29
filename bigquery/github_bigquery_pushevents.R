require(ggplot2)

setwd("~/Dropbox/GA/project/bigquery")

# data pulled from githubarchive
pushevents_yq   <- read.csv("pushevents_by_yearquarter.csv") 
pushevents_yq   <- subset(pushevents_yq, year==2012 | year== 2013)
pushevents_ymd  <- read.csv("pushevents_by_yearmonthday.csv") 
pushevents_ymd  <- subset(pushevents_ymd, year==2012 | year== 2013)
pushevents_stats  <- read.csv("pushevents_stats_2013.csv")

# aggregate across languages
pushevents_yq_total   <- aggregate(pushes_by_lang ~ year + quarter, 
                                 data=pushevents_yq, FUN=sum)
pushevents_ymd_total  <- aggregate(pushes_by_lang ~ year + month + day, 
                                 data=pushevents_ymd, FUN=sum)
pushevents_yd_total   <- aggregate(pushes_by_lang ~ year + day, 
                                  data=pushevents_ymd, FUN=sum)
pushevents_ym_total   <- aggregate(pushes_by_lang ~ year + month, 
                                   data=pushevents_ymd, FUN=sum)

# create month category
pushevents_ymd_total <- transform(pushevents_ymd_total, monthabb = month.abb[month])

# graph total counts by year-quarter
ggplot(pushevents_yq_total, aes(quarter,pushes_by_lang,group=c(year),colour=year)) + 
  geom_point() +
  geom_line() +
  xlab("Quarter") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Quarter") +
  scale_y_continuous(labels=comma) + 
  scale_colour_discrete(name="Year")

yearquarter <- paste(as.character(pushevents_yq_total$year),as.character(pushevents_yq_total$quarter))

ggplot(pushevents_yq_total, aes(yearquarter,pushes_by_lang)) + 
  geom_point() +
  xlab("Year-Quarter") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Quarter") +
  scale_y_continuous(labels=comma) + 
  scale_colour_discrete(name="Year")

# graph total counts by year-month-day
ggplot(pushevents_ymd_total, aes(as.numeric(day),pushes_by_lang,group=month,colour=monthabb)) + 
  geom_point() +
  geom_line() +
  facet_grid(year ~ .) +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Total Push Events by Year-Month-Day of Week") +
  scale_y_continuous(labels=comma) + 
  scale_x_continuous(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Month", 
                        breaks=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

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
  scale_x_continuous(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Year")
dev.off()

# graph average daily counts by day of week
# define errorbars
limits <- aes(ymax=max,ymin=min)
ggplot(pushevents_stats, aes(day,avg)) + 
  geom_point() +
  xlab("Day of Week") +
  ylab("Total") + 
  ggtitle("Average Daily Push Events by Day of Week") +
  scale_y_continuous(labels=comma) + 
  scale_x_continuous(breaks=1:7,
                     labels=c("Sun","Mon","Tues","Wed","Thu","Fri","Sat")) + 
  scale_colour_discrete(name="Year") 