require(doBy)
require(ggplot2)
require(scales)

setwd("~/Dropbox/GA/project")

# data pulled from https://github.com/search
mydata <- read.csv("github_search.csv") 

# summarize
summaryBy(list(c("repos_by_lang_t3"), c("conditions", "year")), data=mydata, FUN=c(min,mean,max,sum))

# subsets: (1) fork:true (2) fork:false
forktrue  = subset(mydata, conditions=="fork:true")
forkfalse = subset(mydata, conditions=="fork:false")

# graph total counts for top 10 language categories 
repos_total <- aggregate(repos_by_lang_t3 ~ conditions + year, data=mydata, FUN=sum)

png('github_search_top10totals.png')
ggplot(repos_total, 
       aes(year, repos_by_lang_t3, group=conditions, colour=conditions)) + 
  geom_point() +
  geom_line() +
  xlab("\nYear") +
  ylab("Total\n") + 
  ggtitle("Total Repos & Projects for the \n Yearly Top 10 GitHub Languages over Time") +
  scale_x_continuous(breaks=2006:2013) +
  scale_y_continuous(labels=comma) + 
  scale_colour_discrete(name="Type", 
                        breaks=c("fork:true", "fork:false"),
                        labels=c("Repos (including forks)", "Projects (excluding forks)")) +
  theme(legend.position=(c(.25,.722)))
dev.off()

# repos
png('github_search_top10totals_coloredbylanguage.png')
ggplot(forktrue, 
       aes(year, repos_by_lang_t3, group=language, colour=language)) + 
  geom_point() +
  geom_line() +
  xlab("\nYear") +
  ylab("Total\n") + 
  ggtitle("Total Repos for the \n Yearly Top 10 GitHub Languages over Time") +
  scale_x_continuous(breaks=2006:2013) +
  scale_y_continuous(limits=c(0,1000000), labels=comma) +
  scale_colour_discrete(name="Language")
dev.off()

png('github_search_top10totals_groupedbylanguage.png')
ggplot(forktrue, aes(year, repos_by_lang_t3)) + 
  facet_wrap(~language) +
  geom_point() +
  xlab("\nYear") +
  ylab("Total\n") + 
  ggtitle("Total Repos for the \n Yearly Top 10 GitHub Languages over Time") +
  scale_y_continuous(limits=c(0,1000000), labels=comma)
dev.off()

# projects
png('github_search_top10totals_coloredbylanguage_forkfalse.png')
ggplot(forkfalse, 
       aes(year, repos_by_lang_t3, group=language, colour=language)) + 
  geom_point() +
  geom_line() +
  xlab("\nYear") +
  ylab("Total\n") + 
  ggtitle("Total Projects for the \n Yearly Top 10 GitHub Languages over Time") +
  scale_x_continuous(breaks=2006:2013) +
  scale_y_continuous(limits=c(0,400000), labels=comma) +
  scale_colour_discrete(name="Language")
dev.off()

png('github_search_top10totals_groupedbylanguage_forkfalse.png')
ggplot(forkfalse, aes(year, repos_by_lang_t3)) + 
  facet_wrap(~language) +
  geom_point() +
  xlab("\nYear") +
  ylab("Total\n") + 
  ggtitle("Total Projects for the \n Yearly Top 10 GitHub Languages over Time") +
  scale_y_continuous(limits=c(0,400000), labels=comma)
dev.off()
