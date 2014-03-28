# QUERY: TOTAL REPOS & PROJECTS (YEAR)
# based on unique repo URL
# (1) ALL
# (2) "PushEvent"
# (3) "CreateEvent" (repos, tags, branches)

# ALL
# repos
SELECT year(repository_created_at) as year, count(distinct(repository_url)) as total_count
FROM [githubarchive:github.timeline]
GROUP BY year
ORDER BY year
	
# projects
SELECT year(repository_created_at) as year, count(distinct(repository_url)) as total_count
FROM [githubarchive:github.timeline]
WHERE repository_fork = "false"
GROUP BY year
ORDER BY year
		
# PushEvent
# repos
SELECT count(distinct(repository_url)) as total_count, year(repository_created_at) as year
FROM [githubarchive:github.timeline]
WHERE type = "PushEvent"
GROUP BY year
ORDER BY year
	
# projects
SELECT count(distinct(repository_url)) as total_count, year(repository_created_at) as year
FROM [githubarchive:github.timeline]
WHERE type = "PushEvent"
AND repository_fork = "false"
GROUP BY year
ORDER BY year
	
# CreateEvent
# repos
SELECT count(distinct(repository_url)) as total_count, year(repository_created_at) as year
FROM [githubarchive:github.timeline]
WHERE type = "CreateEvent"
GROUP BY year
ORDER BY year

# projects
SELECT count(distinct(repository_url)) as total_count, year(repository_created_at) as year
FROM [githubarchive:github.timeline]
WHERE type = "CreateEvent"
AND repository_fork = "false"
GROUP BY year
ORDER BY year
