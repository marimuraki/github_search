# QUERY: TOTAL PUSHES BY LANGUAGE (YEAR-MONTH-DAY)
# pushevents_by_yearmonthday

SELECT year(repository_pushed_at) as year, month(repository_pushed_at) as month, dayofweek(repository_pushed_at) as day, repository_language, count(repository_language) AS pushes_by_lang 
FROM [githubarchive:github.timeline] 
WHERE type == "PushEvent"
GROUP EACH BY year, month, day, repository_language
ORDER BY year, month, day, pushes_by_lang DESC