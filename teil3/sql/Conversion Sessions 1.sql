select count(eventName) as conversionCount, sessionId, date(timeStamp) as day  
from siteEvents 
where eventName = "home_link hover" 
group by day, sessionId 
order by day
