function [JAC,GS] = itmat (A)

D = diag(diag(A));
L = tril(A) - D;
R = triu(A) - D;

disp(['==========================']);
disp(['---- ITERATIONSMATRIX ----']);
disp(['==========================']);

disp(['Jacobi-Verfahren: ']);
JAC = - inv(D) * (L+R)

disp(['Gauss-Seidel-Verfahren: ']);
GS  = - inv(L + D) * R
endfunction
