-- Get sessions
WITH sessions AS (
    SELECT
        siteEvents.pagePath as landingPage,
        siteEvents.sessionId,
        siteEvents.referrerUrl,
        siteEvents.eventName as sessionStartEvent,
        MIN(siteEvents.timeStamp) AS sessionStartTime
    FROM siteEvents
    GROUP BY siteEvents.sessionId
),
-- SELECT * FROM sessions

-- conversions per sessionId
conversions AS (
    SELECT
        siteEvents.sessionId,
        COUNT(siteEvents.eventName) AS totalConversions
    FROM siteEvents
    WHERE siteEvents.eventName = 'home_link hover'
    GROUP BY siteEvents.sessionId
)
-- SELECT * FROM conversions

-- Combine the above to get conversions per session
SELECT
	case 
		when instr(sessions.landingPage, "gclid=") > 0 then "google / cpc" 
		when instr(sessions.landingPage, "utm_source=") > 0 and  instr(sessions.landingPage, "utm_medium=") > 0 then 
		  "campaign (" || substr(sessions.landingPage, instr(sessions.landingPage,"?")+1) ||")"
		when sessions.referrerUrl = "" or sessions.referrerUrl like "%markus-baersch.de%" then "direct"
		when not sessions.referrerUrl = "" then 
		  replace(substr(sessions.referrerUrl, instr(sessions.referrerUrl,"//")+2), "www.", "") || " / referral"  
		else "other"
	end Channel,
    count(sessions.sessionId) as Sessions,
    sum(conversions.totalConversions) as Conversions
	FROM sessions
LEFT JOIN conversions
ON sessions.sessionId = conversions.sessionId
group by Channel
order by Sessions desc
