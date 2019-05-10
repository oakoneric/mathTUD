function [solution , numit] = SOR (A,b,X,w,tol,nmax)
  % A = Matrix (als sparse matrix)
  % b = rechte Seite
  % X = Startvektor
  % w = Parameter
  % tol = Abbruchparameter (Toleranz)
  % nmax = max. Iterationen
  
  
  % ===========================
  % Berechnung der Matrix B
  % ===========================
  N = length(X);  
  
  % Zerlegung in A = L + D
  D = sparse(diag(diag(A)));    % diagonale
  L = sparse(tril(A) - D);      % untere dreiecksmatrix (ohne diagonale)
  
  B = sparse(L + 1/w .* D);       
        
  % ==================
  % Invertierung von B   
  % ==================  
  %tic
    %Binv = inv(B);
    %Binv = speye(size(B))/B;
    Binv = sparse(B)\speye(size(B));
    %disp(['Der Aufbau von inv(B) dauert: ']);
  %toc
  
  
  % ===========================
  % Aufbau der Iterationsmatrix   
  % ===========================

% M = eye(N) - Binv * A;  
% M = (L + 1/w D)^-1 * ((1-w)/w D - R)
  M = Binv * sparse(((1-w)/w .* D - (A - D - L))); 
  c = Binv * b;
        
        
  % ===================
  % Iterationsverfahren
  % ===================
  n = 1;
  fehler = tol+1;
  
  while(n<=nmax && fehler>=tol)
    X      = M * X + c;                      % Iterationsschritt
    n      = n + 1;                          % Iterationsschrittzaehler
    fehler = norm(A * X - b) / norm(b);
  endwhile
  
  
  % =============================
  % Übergabe an Rückgabevariablen
  % =============================
  solution = X;
  numit    = n - 1;
  
endfunction
