require(ggplot2)
require(reshape2)

setwd("~/Dropbox/GA/project/bigquery")

# data pulled from https://github.com/search & githubarchive
mydata <- read.csv("total_comparison.csv") 

# reshape data
mdf <- melt(mydata, id.vars=c("year","type","conditions"), value.name="total", variable.name="query")
mdf$total <- as.numeric(gsub(",","",mdf$total))

# subsets: (1) repos (2) projects
repos = subset(mdf, type=="repos")
projs = subset(mdf, type=="projects")

png('github_total_comparison_repos.png')
ggplot(repos, aes(year,total,group=c(query),colour=query)) + 
  geom_point() +
  geom_line() +
  xlab("Year") +
  ylab("Total") + 
  ggtitle("Total Repos (including forks) by Source") +
  scale_x_continuous(breaks=2006:2013) +
  scale_y_continuous(labels=comma) + 
  scale_colour_discrete(name="Source", 
                        breaks=c("Search", "All", "CreateEvent", "PushEvent"),
                        labels=c("Search", "GitHubArchive", "GitHubArchive:CreateEvent", "GitHubArchive:PushEvent")) +  
  theme(legend.position=(c(.25,.722)))
dev.off()

png('github_total_comparison_projects.png')
ggplot(projs, aes(year,total,group=c(query),colour=query)) + 
  geom_point() +
  geom_line() +
  xlab("Year") +
  ylab("Total") + 
  ggtitle("Total Projects (excluding forks) by Source") +
  scale_x_continuous(breaks=2006:2013) +
  scale_y_continuous(labels=comma) + 
  scale_colour_discrete(name="Source", 
                        breaks=c("Search", "All", "CreateEvent", "PushEvent"),
                        labels=c("Search", "GitHubArchive", "GitHubArchive:CreateEvent", "GitHubArchive:PushEvent")) +  
  theme(legend.position=(c(.25,.722)))
dev.off()
