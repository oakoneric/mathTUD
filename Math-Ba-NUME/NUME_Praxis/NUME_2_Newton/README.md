# Newton-Verfahren im IR^n

## Aufgabe
Schreibe ein Programm zur Lösung eines nichtlinearen Gleichungssystems F(x) = 0 mit dem Newton-Verfahren und dem gedämpften Newton-Verfahren. Für das gedämpfte Newton-Verfahren verwende die hinreichende Abstiegsbedingung nach Goldstein/Armijo.

Teste das Programm anhand des folgenden Beispiels, dokumentiere und interpretiere den
Fehler ||x_n − x*|| und den Defekt ||F(x_n)|| sowie beim gedämpften Newton-Verfahren den Dämpfungsparameter alpha.

F(x) = [ F1(x1, x2) , F2(x1, x2)]

F1(x1,x2) = sin(x1) cos(x2)

F2(x1,x2) = x1^2 + x2^2 -3

Die genau Aufgabenstellung findet sich [hier](http://www.math.tu-dresden.de/~vanselow/Lehre_WiS201819/Numerik/Aufgaben/U_5.pdf).

## Bearbeitung
- [x] Deklaration der Funktion F und der Ableitungsfunktion
- [ ] Implementierung des ungedämpften Newton-Verfahrens
- [x] Implementierung des gedämpften Newton-Verfahrens wie beschrieben
- [ ] Name der Output-Datei als Eingabe fordern
- [ ] Dokumentation für einzelne Werte ausführen

## aktueller Stand
Die Funktion f ist beschrieben in `f.m`, die Ableitungsfunktion in `f2.m`. In der Datei befindet sich momentan das gedämpfte Newton-Verfahren, d.h. der Aufruf `newton ...` startet immer (unabhängig vom Bool-Paramter gedaempft) das gedämpfte Newton-Verfahren. Natürlich soll dann dort noch die Fallunterscheidung in ungedämpftes und gedämpftes Newton-Verfahren erfolgen. Die Dokumentation der Fehler und Deffekte sowie des Dämpfungsparameters erfolgt in der Datei `doc.txt`. In Zukunft soll noch für jeden der zu testenden Eingabewerte eine eigene Output-Datei angelegt werden.

## Test
Im Moment lässt sich die Funktion `newton.m` am einfachsten mit dem Befehl

` newton( [2.7 ; 2.7] , 'f' , 'f2' , 50 , 1 , 0.9 , 0.5 , 10^(-10), [-1/2*sqrt(12 - pi^2) ; pi/2] )`

testen. Dies ist der erste zu testende Wert des gedämpften Newton-Verfahrens auf dem Aufgabenblatt.
