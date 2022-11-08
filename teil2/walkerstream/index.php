<?php
error_reporting(0);
/******************************************************************************************
* Beispielhafter Endpunkt für den Empfang und die Verarbeitung von Website Events, welche *
* mit walker.js (siehe https://docs.elbwalker.com/tagging/basics) gesammelt und als JSON  *
* Payload an diesen Endpunkt versendet werden.                                            * 
******************************************************************************************/


/********************************** SETUP START  **********************************/
//Soll ein einfaches Logfile im Textformat erstellt werden? 
//das sollte freilich nur zu Debug-Zwecken eingesetzt werden, sonst leer lassen
$logfile = "storage/elblog.txt";
//$logfile = "";

//Soll eine Sqlite Datenbank als First Party Ziel für Events genutzt werden, 
//hier einen beliebigen Dateinamen eintragen oder leer lassen 
$sqlitefile = "storage/elblog.data";

/********************************** SETUP ENDE   **********************************/

//kompletten folgenden Block auskommentieren bzw. ersetzen, wenn eine Session ID als Parameter genutzt / gesendet wird. Hier wird exemplarisch die 
//PHP Session ID als Session / "Klammer" um die einzelnen Events verwendet. Es ist auch eine Client ID als Session ID denkbar, die dann als Fingerprint
//hier serverseitig erzeugt wird o. Ä. Im Fall von selbst gehosteten Daten wäre sogar eine gekürzte IP eher umktitisch - ebenso wie die Speicherung
//weiterer Daten wie User Agent o. Ä. aus dem Request. 
session_start([
  'cookie_secure' => true,
  'cookie_httponly' => true,
  'cookie_samesite' => "Strict",
]);
$session = session_id();
session_write_close();

//Die Nutzlast des Hits im POST empfangen, in Objekt umwandeln und einzelne Werte auslesen für Log / DB Speicherung 
$info_string = file_get_contents('php://input');
$info_obj = json_decode($info_string, true);
$event = $info_obj["event"];

//Beispielhafte Prüfung, ob alles da ist - hier kann und sollte ggf. noch sinnvolle 
//weitere Absicherung hinzugefügt werden wie Prüfung des Referrers o. Ä.   
if (($session != "") && ($event != "")) {

  //Im Test-Script zur Versorgung dieses Endpunkts wird eine "page_location" über globale Atttibute für alle Events auf einer Seite bestimmt. Dieser Pfad wird als
  //Seiten-URL verwendet. Es kann aber eine abweichende Seite bzw. ein Pfad z. B. als "id" eines "page view" oder auf andere Weise im "data" Objekt vorhanden sein. 
  $pgurl = $info_obj["globals"]["page_location"];

  //Auf gleiche Weise wird der Referrer als global übergeben:
  $referrer = $info_obj["globals"]["page_referrer"];

  //in lokales Log schreiben?
  if ($logfile != "") {
    $timestamp = date(DATE_ATOM, time());
    if (!file_exists($logfile)) touch($logfile);
    file_put_contents($logfile, "$timestamp\t$session\t$event\t$pgurl\t$referrer\n", FILE_APPEND);
  }

  //Speicherung in lokaler SQlite DB?
  if ($sqlitefile != "") {

    $init = !file_exists($sqlitefile);

    //Verbindung mit der DB
    $db = new SQLite3($sqlitefile);

    //Das checken und anlegen der Tabelle hier muss man streng genommen rauswerfen und die DB lokal erzeugen und hochladen - 
    //wir lassen es hier nun zu Demozwecken einfach drin. Den Call kann und sollte man sich im Echtbetrieb allerdigs sparen. Auch ist diese
    //Struktur der DB nur ein Beispiel mit wenigen Feldern und dem Event als Objekt in einem Datenfeld - das ist nicht ideal für alle denkbaren 
    //Arten von Abfragen und sollte daher nach eigenem Bedarf angepasst werden. Infos zu DB und Struktur siehe https://www.sqlite.org/docs.html  
    if ($init === true) 
      $db-> exec("CREATE TABLE IF NOT EXISTS siteEvents(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
       sessionId TEXT NOT NULL DEFAULT '0',
       clientId TEXT DEFAULT 'none',
       eventName TEXT NOT NULL,
       pagePath TEXT,
       referrerUrl TEXT,
       eventData TEXT)");

    //Neue Zeile in die DB einfügen und Verbindung trennen
    $db-> exec("INSERT INTO siteEvents(sessionId, eventName, pagePath, referrerUrl, eventData) VALUES ('$session', '$event', '$pgurl', '$referrer', '$info_string')");
    $db->close();
  }

  //Geschafft. Einfache Rückmeldung statt Image:
  header('Expires: '.gmdate('D, d M Y H:i:s \G\M\T', time())); // direkt
  echo "$event: OK";
} else {
  //Aufruf war nicht gueltig oder vollstaendig
  header('HTTP/1.0 403 Forbidden');
}
?>