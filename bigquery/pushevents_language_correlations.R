# analyze correlations between languages of actors' PushEvents (2013)

require(Hmisc)
require(lattice)
require(plyr)

setwd("~/Dropbox/GA/project/bigquery/pushevents_by_actor_language")

# append files 
file_list <- list.files()
query     <- do.call("rbind", lapply(file_list, read.csv, header = TRUE))
query     <- query[order(query$repository_language, -query$pushes_by_lang),]

setwd("~/Dropbox/GA/project/bigquery")

# drop duplicates 
# why? shouldn't be any ... possible error in subsetting when exporting from BigQuery
query     <- query[!duplicated(query),]
write.table(query, 
            file="pushevents_by_actor_language.csv", 
            sep=",", 
            row.names=FALSE)

# rank language by total pushevents
query_totals <- aggregate(pushes_by_lang~repository_language, 
                          data=query, 
                          FUN=sum)
query_totals <- query_totals[order(-query_totals$pushes_by_lang),]
colnames(query_totals)[colnames(query_totals)=="pushes_by_lang"] <- "total_by_lang"
query_totals$rank <- rank(-query_totals$total_by_lang)
top25langs        <- subset(query_totals, rank <= 25)

# subset to top 25 popular languages
query_top25langs <- merge(query, top25langs, by="repository_language")
query_top25langs <- query_top25langs[c(1:3)]
write.table(query_top25langs, 
            file="pushevents_by_actor_language_top25.csv", 
            sep=",", 
            row.names=FALSE)

# reshape wide
query_top25langs_wide <- reshape(query_top25langs,idvar="actor", 
                                 timevar="repository_language", 
                                 direction="wide")
query_top25langs_wide[is.na(query_top25langs_wide)] <- 0
query_top25langs_wide <- query_top25langs_wide[c(-1)]

# remove column names
colnames_removing_prefix <- function(df, prefix) {
  names <- colnames(df)
  indices <- (substr(names, 1, nchar(prefix))==prefix)
  names[indices] <- substr(names[indices], nchar(prefix)+1, nchar(names[indices]))
  return(names)
}

colnames(query_top25langs_wide) <- colnames_removing_prefix(query_top25langs_wide, "pushes_by_lang.")

# correlation matrix
png('github_bigquery_pushevents_language_correlations.png')
correlations <- cor(query_top25langs_wide)
levelplot(correlations, 
          at=seq(-1,1,.1), 
          scales=list(x=list(rot=90)), 
          main="Correlation Matrix of\nTop 25 GitHub Languages")
dev.off()

# dissimilarity
dissimilarity <- 1-correlations
distance      <- as.dist(dissimilarity)
plot(hclust(distance))
