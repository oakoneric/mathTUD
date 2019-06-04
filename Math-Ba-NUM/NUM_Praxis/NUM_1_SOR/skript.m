% Lars_Ortscheidt_Eric_Kunze_P1_Octave

clear all
close all

tol  = 10^-6;
nmax = 1500;
z    = [5,10,100,200];

dirichlet = @(x,y) sin(pi * x) * sin(pi * y);
poisson   = @(x,y) 2*(-x^2 + x^3 - (-1 + y) * y + 3 * x * (-1 + y) * y);

%-------------------------------------------------------------------------------

% ==========================================
% Besetztheit der Matrizen A, A invers, L, U
% ==========================================
N = 5;
A = funA(N);
%warning('off');
[L U] = lu(full(A));
%warning('on');


besetzheit = figure('Name', 'Besetzheit der Matrizen');
subplot(2,2,1);
spy(A,'.');    
title('Besetztheit der Matrix A')

subplot(2,2,2);
spy(inv(A),'.');
title('Besetztheit der Inversen Matrix inv(A)')

subplot(2,2,3);
spy(L,'.');
title('Besetztheit der Matrix L der LU-Zerlegung von A')

subplot(2,2,4);
spy(U,'.');
title('Besetztheit der Matrix U der LU-Zerlegung von A')

print(besetzheit, '-dpng','besetztheit.png');

close all


disp(['Klicken zum fortfahren...']);
pause

%-------------------------------------------------------------------------------

% =====================
% PCG UND SOR VERFAHREN
% =====================

for rechteSeite = 1:2
  % 1 = dirichlet = f
  % 2 = poisson   = g
  disp(['============================================']);
  disp([' LOESUNG DURCH PCG UND SOR FUER GEFORDERTE N']);
  if rechteSeite == 1
    disp(['*************** DIRICHLET ******************']);
  else  
    disp(['**************** POISSON *******************']);
  endif
  disp(['============================================']);
  
  for i=1:4
    % jeder schleifendurchlauf nimmt einen wert f�r N
    
    N = z(i);
    omega = [ 1 , 1.8 , 2/(1+(1-(0.5*(cos(pi/(N+1))+cos(pi/(N+1))))^2)^0.5) ];
    
    disp(['-----------------------']);
    disp(['***** Sei N = ', num2str(N), ' *****']);
    disp(['-----------------------']);
    
    if rechteSeite == 1
       b = genfunb(N, dirichlet);
    else
       b = genfunb(N, poisson  );
    endif
    
    A  = funA(N);
    
    PCGverfahren = pcg(A,b,tol,nmax);
    
    for j = 1:3
      w = omega(j);
      disp(['-- Fuer w = ', num2str(w), ' --']);
    
      disp(['Klicken zum fortfahren...']);
      pause
      disp(['... und weiter gehts']);
    
      X = zeros(N*N,1);
      [SORerg, SORIterationen] = SOR(A,b,X,w,tol,nmax);
      disp(['Die Iteration hat nach ', num2str(SORIterationen), ' Iterationen abgebrochen.']);
      clear X
    endfor
    
  endfor
endfor

%-------------------------------------------------------------------------------

% ======================
% FEHLERPLOT FUER N = 10
% ======================
N = 10;
omega = [ 1 , 1.8 , 2/(1+(1-(0.5*(cos(pi/(N+1))+cos(pi/(N+1))))^2)^0.5) ];
b = funb(N);
A = funA(N);

detailfehlerplot =  figure('Name', 'Iterationsfehler im SOR-Verfahren');
fehlerplot =  figure('Name', 'Iterationsfehler im SOR-Verfahren');

for j = 1:3
  w = omega(j);
  X = zeros(N*N,1);
  fehler = fehlervec(A,b,X,w,tol,nmax);
  numit = length(fehler);
  clear X
  
  x = [1:numit];
  figure(fehlerplot);
  plot(x,fehler);
%  plot(numit,fehler(numit),'s');
  hold on
  figure(detailfehlerplot);
  plot(x,fehler);
  hold on
endfor

% --- FEHLERPLOT --- 
figure(fehlerplot);
legend(['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
achse = axis();
title('relativer Fehler im SOR-Iterationsverfahren');
xlabel('Iterationszahl');
ylabel('relativer Fehler');
print(fehlerplot, '-dpng','fehlerplot.png');

% --- DETAILLIERTER FEHLERPLOT ---
figure(detailfehlerplot)
legend(['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
axis([0 200 0 0.0001]);
title('relativer Fehler im SOR-Iterationsverfahren (Detaildarstellung)');
xlabel('Iterationszahl');
ylabel('relativer Fehler');
print(detailfehlerplot, '-dpng','detailfehlerplot.png');

%-------------------------------------------------------------------------------
close all
clear all