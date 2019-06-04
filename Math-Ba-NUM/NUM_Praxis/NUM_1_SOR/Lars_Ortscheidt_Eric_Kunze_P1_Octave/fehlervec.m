% Lars_Ortscheidt_Eric_Kunze_P1_Octave

% simuliert sor verfahren
% aber: liefert fehler-vektor als ergebnis

function fehler = fehlervec (A,b,X,w,tol,nmax)
  % A = Matrix (als sparse matrix)
  % b = rechte Seite
  % X = Startvektor
  % w = Parameter
  % tol = Abbruchparameter (Toleranz)
  % nmax = max. Iterationen
  
  N = length(X);  
  
  % Zerlegung in A = L + D
  D = diag(diag(A));    % diagonale
  L = tril(A,-1);       % untere dreiecksmatrix (ohne diagonale)
  
  B = L + 1/w .* D;    

  clear L
  clear D   
  
        
  % ===================
  % Iterationsverfahren
  % ===================
  n = 1;
  fehler = tol+1;
  
  while(n<=nmax && fehler>=tol)
%   X         = M * X + c;                      % Iterationsschritt
    X         = X - B \ (A*X-b);
    fehler(n) = norm(A * X - b) / norm(b);
    n         = n + 1;                          % Iterationsschrittzaehler
  endwhile

endfunction

