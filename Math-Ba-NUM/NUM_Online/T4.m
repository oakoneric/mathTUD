clear all
warning('off')
A= input('Matrix eingeben: ');
D = diag(diag(A));
L = tril(A) - D;
R = triu(A) - D;

%Gauﬂ Seidel
M_gs = sym(-inv(L+D)*R);
e_gs = sym(eig(M_gs));
disp('Spektralradius Gauﬂ-Seidel Verfahren: ');
max_gs=max(abs(e_gs))

%Jacobi
M_j =sym(-inv(D)*(L+R));
e_j = sym(eig(M_j));
disp('Spektralradius Jacobi Verfahren: ');
max_j=max(abs(e_j))
