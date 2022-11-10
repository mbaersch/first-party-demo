select pagePath, 
  count(case when eventName = 'page view' then 1 end) as pageViews,
  count(distinct(sessionId)) as totalSessions,
  count(case when eventName = 'home_link hover' then 1 end) as homeLinkConversions,
  count(eventName) as totalEvents
from siteEvents
where pagePath <> ""
group by pagePath
order by pageViews desc