/*SUMMEN NACH Landingpage*/
select pagePath, count(id) as totalEvents, 
  count(distinct sessionId) as totalSessions 
from siteEvents 
where (not referrerUrl like 'https://www.markus-baersch.de/%') and pagePath <> ""
group by pagePath
order by count(id) desc