/*SUMMEN für Landingpages und Referrer*/
select pagePath as landingPage, referrerUrl as source, 
  count(case when eventName = "page view" then 1 end) as pageViews, 
  count(id) as totalEvents, 
  count(distinct sessionId) as totalSessions 
from siteEvents 
 where (not referrerUrl like 'https://www.markus-baersch.de/%') and pagePath <> ""
 group by pagePath, referrerUrl
 order by count(id) desc