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

# subset to top 25 popular languages
top25langs        <- subset(query_totals, rank <= 25)
query_top25langs  <- merge(query, top25langs, by="repository_language")
query_top25langs  <- query_top25langs[c(1:3)]

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
correlations <- cor(query_top25langs_wide, method=c("spearman"))

# correlation matrix as level plot
png('github_bigquery_pushevents_language_correlations.png')
levelplot(correlations, 
          at=seq(-1,1,.02), 
          scales=list(x=list(rot=90)), 
          xlab="",
          ylab="",
          main="Correlation Matrix of\nTop 25 GitHub Languages\n(2013)")
dev.off()

# identify top 5 (=10/2) correlations
corrmatrix  <- correlations[-2]
corrmatrix  <- as.matrix(corrmatrix)
l           <- length(corrmatrix)
l1          <- length(corrmatrix[corrmatrix<1])
corrhigh    <- order(corrmatrix)[(l1-9):l1]
corrhighonly    <- corrmatrix
corrhighonly[!1:l %in% corrhigh] <- NA
corrhighonly

# dissimilarity & hierachichal clustering
dissimilarity <- 1-abs(correlations)
distance      <- as.dist(dissimilarity)
png('github_bigquery_pushevents_language_clusters.png')
plot(hclust(distance), 
     xlab="",
     ylab="Dissimilarity Distance",
     main="Hierachical Clustering of\nTop 25 Github Languages\n(2013)")
dev.off()

