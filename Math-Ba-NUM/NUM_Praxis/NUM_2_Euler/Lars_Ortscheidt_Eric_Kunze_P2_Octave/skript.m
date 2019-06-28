% Lars Ortscheidt Eric Kunze P2 Octave

clear all;
close all;

warning('off');

beta  = 2;
alpha = 10;
a = 0;
b = 10;
aw1 = alpha;
aw2 = 10;
h = 1/100;

awa1 = @(x,y) beta*(y-y^2);
awa2 = @(x,y) 10*(sin(x)-cos(5*x));


% analytische Lsg fuer (1)
sol1 = @(x) (alpha*e^(beta*x))/(1-alpha*(1-e^(beta*x)));

% analytische Lsg fuer (2)
sol2 = @(x) -10*cos(x)-2*sin(5*x)+20;  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANFANGSWERTPROBLEM (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------
% explizites Euler-Verfahren | Polygonzugverfahren
% -------------------------------------------------
% exeuler1 enthält die Naeherung fuer die aktuelle Schrittweite an den Gitterstellen
% exeu1 enthält die Naeherungen an der letzten Gitterstelle, i beschreibt dann die Schrittweite
for i=1:8
  h = 0.01 * 0.5^(i-1);
  
  exeuler1 = ex_euler(awa1, h, a, b, aw1);
  poly1    = poly(awa1, h, a, b, aw1);
  
  exeu1(i) = exeuler1(end);  % naeherungsloesung u(10) mit explizitem euler
  pol1(i)  = poly1(end);     % naeherungsloesung u(10) mit polygonzug
endfor

% ---------------------------
% implizites Euler-Verfahren
% ---------------------------
% imeuler1 enthält die Naeherung fuer die aktuelle Schrittweite an den Gitterstellen
% imeu1 enthält die Naeherungen an der letzten Gitterstelle, i beschreibt dann die Schrittweite
for i=1:8
  h = 0.2 *0.5^(i-1);
  
  imeuler1 = im_euler(awa1, h, a, b, aw1, beta);
  
  imeu1(i) = imeuler1(end); % naeherungsloesung u(10) mit implizitem euler
endfor

  
% ---------------------------
% grafísche Darstellung
% ---------------------------

% Schrittweite / Gitter implizites Eulerverfahren
h = 0.2 * 0.5^7; 
x1i = [a:h:b];

% Schrittweite / Gitter explizites Eulerverfahren
h     = 1/100 * 0.5^7; 
x1 = [a:h:b];

loesung1 = figure('Name', 'Lösung (1)');
plot(x1 ,exeuler1);  hold on;
plot(x1 ,poly1)   ;  hold on;
plot(x1i,imeuler1);  hold on;
axis([0 10]);
legend('Explizites Eulerverfahren','verbessertes Polygonzugverfahren','Implizites Euler-Verfahren');
xlabel('x');
ylabel('u(x)');
print(loesung1, '-dpng','loesung1.png');

% ---------------------------
% Fehlerberechnung
% ---------------------------
for i = 1:length(x1)
  fehler11(i) = abs(exeuler1(i) - (sol1(x1(i)))); % Fehler explizites Eulerverf. von exakter Lösung
  fehler12(i) = abs(poly1(i)    - (sol1(x1(i)))); % Fehler verb. Polygonzugverf. von exakter Lösung
endfor
for i = 1:length(x1i)
  fehler13(i) = abs(imeuler1(i) - (sol1(x1(i)))); % Fehler implizites Eulerverf. von exakter Lösung
endfor




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANFANGSWERTPROBLEM (2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% exeuler2 enthält die Naeherung fuer die aktuelle Schrittweite an den Gitterstellen
% exeu2 enthält die Naeherungen an der letzten Gitterstelle, i beschreibt dann die Schrittweite
for i = 1:8
  h = 2 * 0.5^(i-1);
  exeuler2 = ex_euler(awa2, h, a, b, aw2); % exeuler(i) ~ u(x_i)
  poly2    = poly(awa2, h, a, b, aw2);
  
  exeu2(i) = exeuler2(end); % naeherungsloesung u(10) mit explizitem euler
  pol2(i)  = poly2(end);    % naeherungsloesung u(10) mit polygonzug
endfor

% ---------------------------
% grafísche Darstellung
% ---------------------------
x2 = [a:h:b];
loesung2 = figure('Name', 'Lösung (2)');
plot(x2,exeuler2);  hold on;
plot(x2,poly2) ;    hold on;
axis([0 10]);
legend('Explizites Eulerverfahren','verbessertes Polygonzugverfahren');
xlabel('x');
ylabel('u(x)');
print(loesung2, '-dpng','loesung2.png');


% ---------------------------
% Fehlerberechnung
% ---------------------------
for i= 1:length(x2)
  fehler21(i) = abs(exeuler2(i) - (sol2(x2(i)))); % Fehler explizites Eulerverf. von exakter Lösung
  fehler22(i) = abs(poly2(i)    - (sol2(x2(i))));
endfor



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEHLERBERECHNUNG - experimentelle Konvergenzordnung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u10_1 = sol1(10);
u10_2 = sol2(10);

for i = 1:8
  eex1_hN(i) = abs(exeu1(i)- u10_1);
  eex2_hN(i) = abs(exeu2(i)- u10_2);
  epo1_hN(i) = abs(pol1(i) - u10_1);
  epo2_hN(i) = abs(pol2(i) - u10_2);
  eim1_hN(i) = abs(imeu1(i)- u10_1);
endfor

for i= 1:7
  EOC_ex1(i) = (log(eex1_hN(i)) - log(eex1_hN(i+1)))/(log(2));
  EOC_ex2(i) = (log(eex2_hN(i)) - log(eex2_hN(i+1)))/(log(2));
  EOC_po1(i) = (log(epo1_hN(i)) - log(epo1_hN(i+1)))/(log(2));
  EOC_po2(i) = (log(epo2_hN(i)) - log(epo2_hN(i+1)))/(log(2));
  EOC_im1(i) = (log(eim1_hN(i)) - log(eim1_hN(i+1)))/(log(2));
endfor


disp('Experimentelle Konvergenzordnungen:');
disp('===================================');

disp('--- AWA (1) - explizites Eulerverfahren ---');
for i = 1:7
    disp(['EOC fuer die Schrittweiten ', num2str(0.01 * 0.5^(i-1)), ' und ', num2str(0.01 * 0.5^i), ': ', num2str(EOC_ex1(i))]);
endfor
disp('--- AWA (1) - verbessertes Polygonzugverfahren ---');
for i = 1:7
    disp(['EOC fuer die Schrittweiten ', num2str(0.01 * 0.5^(i-1)), ' und ', num2str(0.01 * 0.5^i), ': ', num2str(EOC_po1(i))]);
endfor
disp('--- AWA (1) - implizites Eulerverfahren ---');
for i = 1:7
    disp(['EOC fuer die Schrittweiten ', num2str(0.2 * 0.5^(i-1)), ' und ', num2str(0.2 * 0.5^i), ': ', num2str(EOC_im1(i))]);
endfor
disp('--- AWA (2) - explizites Eulerverfahren ---');
for i = 1:7
    disp(['EOC fuer die Schrittweiten ', num2str(2 * 0.5^(i-1)), ' und ', num2str(2 * 0.5^i), ': ', num2str(EOC_ex2(i))]);
endfor
disp('--- AWA (2) - verbessertes Polygonzugverfahren ---');
for i = 1:7
    disp(['EOC fuer die Schrittweiten ', num2str(2 * 0.5^(i-1)), ' und ', num2str(2 * 0.5^i), ': ', num2str(EOC_po2(i))]);
endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEHLERPLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fehlerplot1 = figure('Name', 'Fehler (1)');
subplot(2,1,1)
plot(x1 , fehler11);   hold on ;
plot(x1 , fehler12);   hold on ;

title('Fehler von AWP (1)');
xlabel('x');
ylabel('Fehler');
legend('Fehler expl. Euler','Fehler verb. Polygonzug');

subplot(2,1,2)
plot(x1, fehler11);   hold on ;
plot(x1, fehler12);   hold on ;
plot(x1i, fehler13);   hold on ;

title('Fehler von AWP (1)');
xlabel('x');
ylabel('Fehler');
legend('Fehler expl. Euler','Fehler verb. Polygonzug','Fehler impl. Euler');
set(gca, 'YScale', 'log')

print(fehlerplot1, '-dpng','fehler1.png');

%----------------------------

fehlerplot2 = figure('Name', 'Fehler (2)');
plot(x2, fehler21);   hold on ;
plot(x2, fehler22);   hold on ;

title('Fehler von AWP (2)');
xlabel('x');
ylabel('Fehler');
legend('Fehler expl. Euler','Fehler verb. Polygonzug');

print(fehlerplot2, '-dpng','fehler2.png');