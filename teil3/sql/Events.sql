/*SUMMEN NACH EVENT*/
select eventName, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
from siteEvents group by eventName 
order by count(id) desc