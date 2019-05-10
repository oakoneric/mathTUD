clear all
close all

tol  = 10^-6;
nmax = 1500;
z    = [5,10,100,200];

% ==========================================
% Besetztheit der Matrizen A, A invers, L, U
% ==========================================
N = 5;
%A = spdiags(funA(N), [-N,-1,0,1,N], N^2, N^2);
%[L U] = lu(A);
%figure(1);
%spy(A);                    %Beschriftung hinzufuegen?!
%figure(2);
%spy(inv(A));
%figure(3);
%spy(L);
%figure(4);
%spy(U);

%"Klicken zum fortfahren"
%pause

% =====================
% CGS UND SOR VERFAHREN
% =====================

  disp(['===========================================']);
  disp([' LOESUNG DURCH CGS UND SOR FUER GEFORDERTE N']);
  disp(['===========================================']);

for i=1:3
  % jeder schleifendurchlauf nimmt einen wert für N
  
  N = z(i);
  omega = [ 1 , 1.8 , 2/(1+(1-(0.5*(cos(pi/(N+1))+cos(pi/(N+1)))))^0.5) ];
  
  disp(['----------------------']);
  disp(['***** Sei N = ', num2str(N), ' *****']);
  disp(['----------------------']);
  
  b = funb(N);
  A = funA(N);
  
  CGSverfahren = cgs(A,b,tol,nmax);
  
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

%und alles nochmal fuer funb2
