#das hier muss einmalig passieren, wenn die Packages nicht vorhanden sind
#dazu die folgenden Zeilen auskommentieren und einmal  ausführen

#install.packages("RSQLite")
#install.packages("DBI")
#install.packages("ggplot2")

#Ladeb der 
library(RSQLite)
library(DBI)
library(ggplot2)

#Verbindung zur DB: Hier Pfad zur lokalen Datenbank eingeben
con <- dbConnect(RSQLite::SQLite(), "elblog.data")

#easy (aber meistens unnötig): Alle Events laden und dann "lokal" auswerten
allSiteData <- dbReadTable(con, "siteEvents")


#Summen für Events und Sitzungen nach Seiten
pageData <- dbGetQuery(con, "select pagePath, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
                            from siteEvents where not pagePath = '' 
                            group by pagePath 
                            order by count(id) desc")

#Nur Summen für Seitenaufrufe nach URL
pageData <- dbGetQuery(con, "select pagePath, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
                            from siteEvents where not pagePath = '' and eventName = 'page_view' 
                            group by pagePath 
                            order by count(id) desc")


#Summen nach Event Name
eventData <- dbGetQuery(con, "select eventName, count(id) as totalEvents, count(distinct sessionId) as totalSessions 
                            from siteEvents group by eventName 
                            order by count(id) desc")


#Event-Summen nach Tagen
dayData <- dbGetQuery(con, "select date(timeStamp) as day, count(id) as totalEvents, 
                            count(distinct sessionId) as totalSessions 
                            from siteEvents 
                            group by day
                            order by count(id) desc")

#oder lieber nur Seitenaufrufe?
dayPvData <- dbGetQuery(con, "select date(timeStamp) as day, count(id) as totalPageviews, count(distinct sessionId) as totalSessions 
                            from siteEvents 
							where eventName = 'page_view'
                            group by day
                            order by totalPageviews desc")



#Alles da, Verbindung wird nicht mehr benötigt
dbDisconnect(con)


#Sitzungen nach Tag in Balkendiagramm...
ggplot(dayData, aes(day)) + 
  geom_bar(aes(y = totalSessions), 
           stat = "identity", 
           color = "orange", 
           width=.7, 
           fill = "orange") + 
  ggtitle("Monatliches Sitzungsvolumen") + xlab("Monat") + ylab("Sitzungen") + theme_bw()


#oder Seitenaufrufe nach Tag?
ggplot(dayPvData, aes(day)) + 
  geom_bar(aes(y = totalPageviews), 
         stat = "identity", 
         color = "darkblue", 
         width=.7, 
         fill = "darkblue") + 
  ggtitle("Anzahl Seitenaufrufe pro Tag") + xlab("Monat") + ylab("Seitenaufrufe") 