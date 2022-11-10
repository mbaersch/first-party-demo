/*SUMMEN NACH TAGEN*/
select date(timeStamp) as Day, count(id) as Events, count(distinct sessionId) as Sessions
from siteEvents 
group by Day
order by Day 