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
    sessions.landingPage,
    sessions.referrerUrl,
    sessions.sessionStartTime,
    conversions.totalConversions
FROM sessions
LEFT JOIN conversions
ON sessions.sessionId = conversions.sessionId;