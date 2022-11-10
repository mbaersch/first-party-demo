/*SUMMEN NACH SEITE*/
select referrerUrl, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
from siteEvents where not referrerUrl like 'https://www.markus-baersch.de/%' and not referrerUrl = ""
group by referrerUrl
order by count(id) desc