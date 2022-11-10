/*SEITENAUFRUFE NACH TAGEN*/
select date(timeStamp) as day, count(id) as totalPageviews, count(distinct sessionId) as totalSessions 
from siteEvents 
where eventName = 'page view'
group by day
order by day desc