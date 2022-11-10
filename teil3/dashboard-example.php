<!doctype html><html lang="de">
<head>
<title>First Party Data Dashboard (AKA "dumb event dump")</title>
<style>
    body {font-family:arial;color:#fff;line-height:1.4em;background:#333}
    h1, h2, h3, h4 {color:#979797; margin-top:0}
    a, h2 {color:#32a127; font-weight: bold}
    #cnt {position: relative; max-width:1000px; margin: 10px auto; text-align:left; padding:1em}

    .scorecard, .card {border-radius: 8px; background: #222; padding: 1em; }
    .scorecard a {text-decoration:none}
    .scorecard {text-align:center; display:inline-block; margin:1em 1em 1em 0}
    .scorecard span {font-size:2em}
    .card { margin:1em 0}
    .full {clear:both}
    .half_r {float:right;width:45%}
    .half_l {float:left;width:45%}
    table {border-radius: 8px; width:100%; background:#b7b7b7; color: #222}
    td, th {padding:2px 5px; max-width:400px; text-align:right}
    td:first-child, th:first-child {text-align:left}

    .chart {border-radius: 8px; color:#222; clear:both; overflow:auto; background:#b7b7b7;height:220px; padding:2em}
    .bar {position:relative; background:#32a127;width:80px; height: 200px; border-right:20px solid #b7b7b7; float:left}
    .bar:before, .bar:after {width:80px; padding-top: 6px; position: absolute; font-size:0.8em; text-align:center; left:0; display: inline-block}
    .bar:after {content:attr(data-name);top: 100%;}
    .bar:before {content:attr(data-value); bottom:5px}
    .bar span {display:block;background:#b7b7b7;}

</style>
</head>
<body>
<div id="cnt">
<h2>First Party Demo Statistik - <small>Alle Daten</small></h2>
<?php

$sqlitefile = "walkerstream/storage/elblog.data";

/************************ HILFSKRAM ************************************/
//Einfache Ausgabe eines SQL Abfrage-Ergebnis als Tabelle
function build_res_table($results, $echo, $class, $title) {
    $res = "<div class='$class'><h3>$title</h3><table><tr>";
    $ct = $results->numColumns();
    for ($x = 0; $x < $ct; $x++) {
        $res .= '<th>'.$results->columnName($x).'</th>';
    }
    $res .=  "</tr>"; 
    while($row=$results->fetchArray(SQLITE3_ASSOC)){
        $res .=  '<tr>';
        for ($x = 0; $x < $ct; $x++) {
            $res .=  '<td>'.$row[$results->columnName($x)].'</td>';
        }
        $res .=  '</tr>';
    }
    $res .=  '</table></div>';
    if ($echo == true) echo $res;
    return $res;
}

function build_chart($results, $echo, $colName, $maxVal, $maxBars, $lblName, $title) {
    $res = "<div class='card'><h3>$title</h3><div class='chart'>";
    $ct = 0;
    while($ct < $maxBars && $row=$results->fetchArray(SQLITE3_ASSOC)){
        $barValue = $row[$colName];
        $calcHeight = ($maxVal - $row[$colName]);
        $res .=  '<div class="bar" data-value="' . $barValue . 
                 '" data-name="' . $row[$lblName] . '">'.
                 '<span style="height:'.$calcHeight.'px"></span>'.
                 '</div>';
        $ct++;         

    }
    $res .=  '</div></div>';
    if ($echo == true) echo $res;
    return $res;
}

function build_scorecard($metric, $value) {
    return "<div class='scorecard'><h3>$metric</h3><span>$value</span></div>";
}

/************************ START ************************************/

if ($sqlitefile == "") die("Keine Datenbank?");

//Verbindung mit der DB  
$db = new SQLite3($sqlitefile);

//Einfache Ausgabe der Ergebnisse. Annahme: "home_link hover" ist hier das Conversion-Event
$rs = $db->query('select count(*) as Events,
   count(distinct sessionId) as Sessions,
   count(case when eventName = "page view" then 1 end) as Pageviews,
   count(case when eventName = "home_link hover" then 1 end) as Conversions 
   from siteEvents')->fetchArray(SQLITE3_ASSOC);

//Freie Wahl: Wir können Ergebnisse aufbereiten, rechnen etc. - auch ohne SQL   
$sc = $rs["Sessions"];   
$pc = $rs["Pageviews"];   

echo build_scorecard("Sessions", $sc);   
echo build_scorecard("Events", $rs["Events"]);   
echo build_scorecard("Pageviews", $pc);   
echo build_scorecard("Conversions", $rs["Conversions"]);   
echo build_scorecard("Pages/Session", number_format($pc/$sc,2,",","."));   
echo build_scorecard("Stand: ".date("d.m.y")." <a href='#' ".
   "onclick='location.reload();return false'>&#128472;</a>", date("H:i:s"));   

$daybyday = $db->query('select date(timeStamp) as Day, count(id) as Events, 
count(distinct sessionId) as Sessions, 
count(case when eventName = "page view" then 1 end) as Pageviews,
count(case when eventName = "home_link hover" then 1 end) as Conversions 
from siteEvents 
group by Day
order by Day limit 14');

//Das geht sicher einfacher, aber darum geht es hier nicht ;) 
$max = $db->query("select max(sessions) as MaxSessions, max(events) as MaxEvents from (
    select date(timeStamp) as Day, count(id) as Events, count(distinct sessionId) as Sessions
    from siteEvents 
    group by Day
    order by Day limit 14)")->fetchArray(SQLITE3_ASSOC);

//Einfaches Chart    
build_chart($daybyday, true, "Events", $max["MaxEvents"], 10, "Day", "Events pro Tag");

//... und Tabelle dazu
build_res_table($daybyday, true, "card full", "Summen nach Tagen");

build_res_table($db->query('select eventName as "Event Name", 
  count(id) as "Events", count(distinct sessionId) as "Sessions" 
from siteEvents group by eventName 
order by count(id) desc limit 50'), true, "card half_l", "Top Events");

build_res_table($db->query('select referrerUrl as Referrer, count(id) as Events, 
  count(distinct sessionId) as Sessions 
from siteEvents where not referrerUrl like "%markus-baersch.de/%" and not referrerUrl = ""
group by referrerUrl
order by count(id) desc limit 50'), true, "card half_r", "Top Referrer");

build_res_table($db->query('select pagePath as Page, 
  count(case when eventName = "page view" then 1 end) as Views,
  count(distinct(sessionId)) as Sessions,
  count(case when eventName = "home_link hover" then 1 end) as Conversions,
  count(eventName) as Events
from siteEvents
where pagePath <> ""
group by Page
order by Views desc
limit 15'), true, "card full", "Top 15 Seiten");

build_res_table($db->query('select pagePath as Landingpage, count(id) as Events, 
  count(distinct sessionId) as Sessions 
from siteEvents 
where (not referrerUrl like "%markus-baersch.de/%") and pagePath <> ""
group by pagePath
order by count(id) desc limit 10'), true, "card full", "Top 10 Landingpages");

build_res_table($db->query('WITH sessions AS (
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
    WHERE siteEvents.eventName = "home_link hover"
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
order by Sessions desc limit 20
'), true, "card full", "Top 20 Channels (einfach)");

//Weitere Beispiele: siehe SQL Examples aus dem GitHub Repository

$db->close();

?>
</div>
</body>
</html>