/*SESSIONS MIT CONVERSIONS*/
select eventName as conversionName, sessionId as conversionSession 
from siteEvents where eventName = "home_link hover"