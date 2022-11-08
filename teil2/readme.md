# Codebeispiele zu Teil 2: Der eigene Endpunkt

Die Dateien dieses Verzeichnisses enthalten den Code aus dem zweiten Video des Workshops (siehe [Playlist auf YouTube](https://www.youtube.com/watch?v=juzaUNb55t4&list=PLoPHZR6Jh3an0Rw_8gFQolsaQULKbvoEC)). Dabei sind auch wieder die HTML Seiten aus dem ersten Teil - hier inkl. der kleinen Anpassungen (exemplarischer Bot-Filter). 
Der Pfad `elbstream/` enthält den Code des exemplatischen Endpunkts aus dem Video, der zum Test zusammen mit den HTML- Dateien auf einem mit PHP ausgestatteten Server hochgeladen werden bzw. mit einem lokalen Webserver erprobt werden muss, wenn die Beispiele nachvollzogen werden sollen. 

Im Ordner ssGTM findet sich das verwendete Client-Template für den serverside Google Tag Manager. Wer dieses ausbauen mag, kann vielleicht auch etwas mit dem angesprochenen E-Book anfangen ;) https://www.markus-baersch.de/gtm-server-templates-buch/ 

## Weitere Links
- Wer mit Compute Engine einen Testserver aufsetzen will: 
  - [Anleitung für Wevserver](https://cloud.google.com/community/tutorials/setting-up-lamp) 
  - oder [Das hier](https://console.cloud.google.com/marketplace/product/jetware/lamp7)
  - Bei CORS Problemem passende Header direkt vom Server senden. Auch dazu eine [exemplarische Anleitung](https://techexpert.tips/apache/apache-add-header/)
- Daten bewegen in der GCP von Text zu BugQuery: [Beispiel-Anleitung](https://www.ternarydata.com/news/use-python-and-google-cloud-to-schedule-a-file-download-and-load-into-bigquery-3p3aw)
- Serverside Fingerprint statt Cookie für "Sessionizing": [Codebeispiel](https://gist.github.com/mbaersch/e492ecfa1802b9736fefcc983b8b557f#file-getclient2-php) ohne wechselnden Hash (dem man dann aber implementieren sollte, wie angesprochen!)
- Beispiel zur etwas komplexeren Bot-Erkennung im Browser: [JS Funktion als Beispiel](https://gist.github.com/mbaersch/117faa0513ebbcbeeeb8d2dbe83168f0). Hier kann zumindest die Liste der bekannten Bot User Agents verwendet werden für ein "echtes" Setup. Wahlweise im Browser - oder am Endpunkt
  - Für den GTM / ssGTM gibt es dazu auch Templates in der Gallery (und hier als Repository). In Der Gallery beim Hinzufügen von Variablen-Templates nach "Simple Bot Detector" suchen ;)    
