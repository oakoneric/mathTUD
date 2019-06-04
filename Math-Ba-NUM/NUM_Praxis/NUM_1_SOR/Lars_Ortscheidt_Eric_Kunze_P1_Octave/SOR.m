% Lars_Ortscheidt_Eric_Kunze_P1_Octave

function [erg , numit] = SOR (A,b,X,w,tol,nmax)
  % A = Matrix (als sparse matrix)
  % b = rechte Seite
  % X = Startvektor
  % w = Relaxationsparameter
  % tol = Abbruchparameter (Toleranz)
  % nmax = max. Iterationen
  
  
  % ===========================
  % Berechnung der Matrix B
  % ===========================
  N = length(X);  
  
  % Zerlegung in A = L + D
  D = diag(diag(A));    % diagonale
  L = tril(A,-1);       % untere dreiecksmatrix (ohne diagonale)
  
  B = L + 1/w .* D;    

  clear L
  clear D   
        
  % ==================
  % Invertierung von B   
  % ==================  
  %tic
    %Binv = inv(B);
    %Binv = speye(size(B))/B;
    %Binv = B\speye(size(B));
    %disp(['Der Aufbau von inv(B) dauert: ']);
  %toc
  
  % ===========================
  % Aufbau der Iterationsmatrix   
  % ===========================
%
%  M = eye(N) - Binv * A;  
%  M = (L + 1/w D)^-1 * ((1-w)/w D - R)
%  M = Binv * ((1-w)/w .* D - (A - D - L)); 
%  c = Binv * b;
%  
 
        
  % ===================
  % Iterationsverfahren
  % ===================
  n = 1;
  fehler = tol+1;
  
  while(n<=nmax && fehler>=tol)
%   X      = M * X + c;                      % Iterationsschritt
    X      = X - B \ (A*X-b);
    n      = n + 1;                          % Iterationsschrittzaehler
    fehler = norm(A * X - b) / norm(b);
  endwhile
  
  
  % =============================
  % Übergabe an Rückgabevariablen
  % =============================
  erg   = X;
  numit = n - 1;
  
endfunction
