# pushevents_by_actor_language

SELECT actor, repository_language, count(repository_language) as pushes_by_lang
FROM [githubarchive:github.timeline] 
WHERE type == "PushEvent"
AND repository_language IS NOT NULL
AND year(repository_pushed_at)=2013
GROUP EACH BY actor, repository_language
ORDER BY actor, repository_language
