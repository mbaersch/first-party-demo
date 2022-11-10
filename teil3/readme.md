# Codebeispiele zu Teil 3: Nutzung der Daten

Die Dateien dieses Verzeichnisses enthalten den Code aus dem dritten Video des Workshops (siehe [Playlist auf YouTube](https://www.youtube.com/watch?v=juzaUNb55t4&list=PLoPHZR6Jh3an0Rw_8gFQolsaQULKbvoEC)). 

Für den Test-Ordner mit den HTML Dateien und dem Ordner für den Endpunkt kommt diesmal nur die exemplarische Seite zur Erstellung eines einfachen Dashboards über einige wenige PHP Abfragen und fast ohne "lokale" Weiterverarbeitung oder Anreicherung der Informationen in den Tabellen.

Der Pfad `sql` sind alle Afragen aus dem DB Editor in exportierter und unveränderter Form vorhanden. Das bedeutet - genau wie beim obigen Code für das Dashboard - dass hier einige Dinge angepasst werden müssen, um z. B. anhand der Domain einen Eintritt zu erkennen (im Beispiel eben markus-baersch.de als Testdomain). Auch die angesprochenen Regeln zum Extrahieren von Click Ids etc. fuktionieren nur unter den Bedingungen der Testdaten und müssen sicher angepasst oder in weiteren Schritten (R ist auch hier eine gute Wahl) nachbearbeitet werden, um die im Video gezeigten Ergebnisse mit eigenen Testdaten zu wiederholen.  

Unter `R` ist das verwendete R-Script mit einigen weiteren Kommentaren zu finden, um den Einstieg zu erleichtern.

## Weitere Links
- SQL in SQLite: https://www.sqlite.org/lang.html
- Tutorial: https://www.sqlitetutorial.net/ 
- Video zur Nutzung von SQLite Daten in R: https://www.youtube.com/watch?v=ZfliyOawJFk
- Template für GAds Conversion Import: https://support.google.com/google-ads/answer/7014069?hl=de