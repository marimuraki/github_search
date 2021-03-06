# QUERY: TOTAL PUSHES BY LANGUAGE (YEAR-QUARTER)
# pushevents_by_yearquarter

SELECT year(repository_pushed_at) as year, quarter(repository_pushed_at) as quarter, repository_language, count(*) AS pushes_by_lang 
FROM [githubarchive:github.timeline] 
WHERE type == "PushEvent"
GROUP EACH BY year, quarter, repository_language
ORDER BY year, quarter, pushes_by_lang DESC

SELECT year(repository_pushed_at) as year, quarter(repository_pushed_at) as quarter, repository_language, count(*) AS pushes_by_lang 
FROM [githubarchive:github.timeline] 
WHERE type == "PushEvent"
AND repository_fork = "false"
GROUP EACH BY year, quarter, repository_language
ORDER BY year, quarter, pushes_by_lang DESC
