select substr(pagePath, 
       instr(pagePath, "gclid=")+6) as "Google Click ID", 
       "Import Conversion Name hier" as "Conversion Name", 
       timeStamp as "Conversion Time", 
	   42.0 as "Conversion Value", 
	   "EUR" as "Conversion Currency" from 
  (select distinct referrerUrl, timeStamp, sessionId, pagePath from siteEvents where sessionId in (
    select distinct sessionId from siteEvents where eventName = "home_link hover"
)   and pagePath like "%gclid=%") 
