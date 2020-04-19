=========================================================
OPTIMIERUNG & NUMERIK - Teil 1
Praxisaufgabe: modulbegleitende Aufgabe 3 & 4
=========================================================
Lars Ortscheidt (Matr.-Nr.: 4720642)
Eric Kunze (Matr.-Nr.: 4679202)
Studiengang: Mathematik, Bachelor, PO 2016
---------------------------------------------------------

Anhang:
* simplex_ortscheidt_lars_kunze_eric.m
* print_tableau.m
* simplex.m
* example1.m
* example2.m
* example3.m
* example4.m
* example5.m
* example6.m
* example7.m
* task2a.m
* task2b.m

Für die lineare Optimierungsaufgabe
	z = transpose(c) x -> min    bei     Ax=b, x>=0
liefert der Funktionsaufruf 
	simplex_ortscheidt_lars_kunze_eric(A,b,c)
die Lösung x und und den Zielfunktionswert z, sofern eine solche Lösung existiert. Sonst wird der entsprechende Kommentar ausgegeben.

Abhängigkeiten des Funktionsaufrufs:
Für einen erfolgreichen Funktionsaufruf müssen die folgenden weiteren Funktionen sichtbar sein:
* print_tableau.m
* simplex.m

Die example-Files und task2_-files lesen jeweils unterschiedliche Matrizen A bzw. Vektoren b und c ein. Die beiden task2a.m bzw. task2b.m stehen dafür für die beiden Teilaufgaben in Aufgabe 4.

Bemerkung:
Die Funktionen sind in Octave geschrieben, da wir die Nutzung proprietärer Software verhindern wollen. Wir hoffen, dass die Matlab-Version auch läuft, können das aber nicht garantieren. Deswegen bitten wir um Entschuldigung und um den Test des Programms mit Octave, welches frei online verfügbar ist.
Wir bitten darum, in Zukunft den Zwang zu proprietärer Software zu verhindern und gerade auch die Nutzung freier Software zu fördern.


---------------------------
Modulbegleitende Aufgabe 4:
---------------------------
Wir lösen die Gleichungssysteme, indem wir die Optimierungsaufgabe transpose(c) x -> min bei Ax=b und x>=0 lösen. Dabei ist c aus IRn beliebig wählbar, da jede Lösung der Optimierunsaufgabe auch die beiden Nebenbedingungen Ax=b und x>=0 erfüllen muss. Somit ist jede Lösung der Optimierunsaufgabe auch eine Lösung des Gleichungssystem Ax=b mit x>=0.
Man kann auch die Zielfunktion als Nullfunktion setzen, dann ist jeder die Nebenbedingung erfüllende Vektor x auch ein optimaler Vektor. Genauso kann man aber auch (wie wir) über die Summe der Einträge in x minimieren, bei Positivität der Einträge erhält man min dem Minimum trotzdem einen zulässigen Vektor, der also das Gleichungssystem löst.

Teilaufgabe (a):

Das letzte Simplex-Tableau sieht wie folgt aus:
|====||========||========|
| T0 || x3     ||      1 |
|====||========||========|
| x2 ||  2.000 ||  5.000 |
| x4 ||  1.000 ||  5.000 |
| x1 ||  1.000 ||  2.000 |
|====||========||========|
| z= ||  5.000 || 12.000 |
|====||========||========|

Dementsprechend ist x = (x1,x2,x3,x4) = (2,5,0,5) eine (positive) Lösung des Gleichungssystems.

Teilaufgabe (b):

Das Simplex-Verfahren liefert eine leere Lösungsmenge, d.h. die Optimierungsaufgabe ist nicht lösbar unter den gegebenen Nebenbedingungen. Dies bedeutet aber bereits, dass Ax=b keine positive (!) Lösung besitzen kann, denn dann gäbe es zumindest eine Lösung der Optimierungsaufgabe.