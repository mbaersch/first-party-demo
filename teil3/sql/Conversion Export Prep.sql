select distinct referrerUrl as Source, timestamp as ConversionTime, pagePath as LandingPage from siteEvents where sessionId in (
  select distinct sessionId from siteEvents where eventName = "home_link hover"
) and pagePath like "%gclid=%"