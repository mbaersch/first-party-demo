//Funktion zum Schreiben in elbLayer
function elb() {
    (window.elbLayer = window.elbLayer || []).push(arguments);
}

(function() {
    //Erzeugung von globalen Eigenschaften für akt. URL und ggf. Referrer als DOM Elemente auf jeder Seite
    var ref = document.referrer;
    if (ref) {
        var rf = document.createElement("span");
        rf.dataset.elbglobals = "page_referrer:'"+ref+"'";
        document.body.appendChild(rf);
    }

    var pg = document.createElement("span");
    pg.dataset.elbglobals = "page_location:'"+document.location.href+"'";
    document.body.appendChild(pg);

    //Initialisierung
    var endpointUrl = 'walkerstream/';
    elb("walker destination", { push: 
        function (event) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', endpointUrl, true);
        xhr.setRequestHeader('Content-type', 'text/plain; charset=utf-8');
        xhr.send(JSON.stringify(event));
        //Logging in Konsole für einfaches Debugging - im Echtbetrieb freilich unnoetig
        console.log(event);
    } 
    });
    elb("walker run");
})()
