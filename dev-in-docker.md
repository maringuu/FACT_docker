## Anforderungen
- python autocompletion: Geht dank venvs `pip install $(fd requirements)`
    * Das venv kann nicht in den container gemountet werden, wegen anderem system (alpine vs host). Macht eh keinen sinn das zu mounten, man sollte nur schauen dass im container die richtigen versionen installiert sind.
- Autocompletion von sonsigen Dateien
    * Sollte funktionieren bis auf die dateien die vom installer geladen werden
        * ~Die kann man gut mit `docker cp` herausfiltern. Vorher mit `rm .gitignore && git status -u` herausfinden, welche man überhaupt braucht.~
        * Eigentlich braucht man die Dateien gar nicht. Trotzdem wäre es sinnvoll die dateien zu "sehen" damit man sich nicht wundert von welchen dateien die Rede ist.
        * Siehe copy-artifacts.sh
- pytest laufen lassen:
    * Sollte problemlos in der shell gehen
- Neue dependencys hinzufügen
    * Etwas problematisch, weil man den container neu bauen muss
    * Man kann die natürlich auch einfach im laufenden Container installieren
        * Dann müsste man in zukunft den gleichn container wieder starten, das ist mit docker-compose gut machbar

## Idee
Man baut einen fact-dev container, der einfach nur eine fact installation beinhaltet.
Der container basiert auf alpine (oder arch).
Jegliche andere installation von FACT wird nicht unterstützt.
Auf alpine kann man fact natürlich trotzdem nativ installieren, wenn man sich die commands im Dockerfile anschaut.
Zum entwickeln auf anderen platformen kann man den container benutzen.
Dafür wird das was man entwickelt hat in den container gemountet und dort gestartet.

## Vorteile
- Der installer kann komplett entfernt werden und durch ein Dockerfile ersetzt werden
    * Weniger arbeit für Rene mit der CI
    * Die CI sollte deutlich schneller sein, dank alpine apk
    * Man "braucht" weniger docker container, weil die pakete in alpine aktuell sind
    * Der DAU braucht ohnehin keinen installer mehr, da er einfach docker benutzen kann

## Probleme
- Kein sinnvoller entrypoint:
    * Man könnte /bin/bash nehmen, aber es ist nicht im Sinne des Erfinders
- Die Dateien vom installer werden durch den mount overshaddowed (Lösung: copy-artifacts.sh)
- Die fact Entwicklung setzt Erfahrung mit docker vorraus
    * Das docker setup generiert garantiert probleme
        * Die probleme sind hoffentlich weniger schwergewichtig, als die Maintance von den riesigen installer
- Die nutzer im container passen nicht ganz zusammen mit denen von außerhalb. (podman --userns=keep-id)
    * Mit `docker run --user $(id -u):$(id -g)` könnte das ganz gut klappen, allerdings muss man bedenken dass das natürlich nicht mehr der benutzer ist mit dem fact installiert wurde
- Was wenn man dependencys hinzufügen will? Oder einen andren branch (mit anderen deps) auschecken will?
    * Letzteres ist genau wie wenn man docker nicht benutzen würde
    * Ersteres lässt sich nur lösen wenn man für die Entwicklung die ganze zeit den gleichen container benutzt
