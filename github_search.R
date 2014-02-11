#install.packages('doBy')
#install.packages('ggplot2')
library(doBy)
library(ggplot2)
require(scales)

setwd("~/Dropbox/GA/project")

# data pulled from https://github.com/search
# TODO: pull data using GitHub API
mydata <- read.csv("github_search.csv") 
names(mydata)
attach(mydata)
mydatasorted <- mydata[order(search_parameter, year, repos),]
detach(mydata)

# summarize by [year]
summaryBy(repos~year, data=mydata, FUN=function(x)
  c(count=length(x),sum=sum(x)))

# graph total counts for top 10 language categories 
repos_total <- aggregate(repos~year, data=mydata, FUN="sum")
png('github_search_top10totals.png')
qplot(year, repos, data=repos_total, 
      main="Total Repos for Yearly Top 10 GitHub Languages over Time",
      xlab="Year", ylab="# of Repos") + 
      scale_y_continuous(labels=comma)
dev.off

png('github_search_top10totals_coloredbylanguage.png')
qplot(year, repos, data=mydata, color=language, 
      main="Total Repos for Yearly Top 10 GitHub Languages over Time",
      xlab="Year", ylab="# of Repos") + labs(color="Language") +
      scale_y_continuous(labels=comma)
dev.off

#q <- ggplot(mydata, aes(x=year, y=repos))
#q + geom_point(aes(color=language))

png('github_search_top10totals_groupedbylanguage.png')
qplot(data=mydata, x=year, y=repos, facets = ~language, 
      main="Total Repos for Yearly Top 10 GitHub Languages over Time",
      xlab="Year", ylab="# of Repos") +
      scale_y_continuous(labels=comma)
dev.off
