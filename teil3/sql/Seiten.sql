/*SUMMEN NACH SEITE*/
select pagePath, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
from siteEvents where not pagePath = '' 
group by pagePath
order by count(id) desc