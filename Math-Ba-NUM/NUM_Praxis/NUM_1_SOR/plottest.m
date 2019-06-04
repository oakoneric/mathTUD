tol  = 10^-6;
nmax = 1500;
z    = [5,10,100,200];

dirichlet = @(x,y) sin(pi * x) * sin(pi * y);
poisson   = @(x,y) 2*(-x^2 + x^3 - (-1 + y) * y + 3 * x * (-1 + y) * y);

N = 10;
omega = [ 1 , 1.8 , 2/(1+(1-(0.5*(cos(pi/(N+1))+cos(pi/(N+1))))^2)^0.5) ];
b1 = genfunb(N,dirichlet);
b2 = genfunb(N,poisson);
A = funA(N);

fehlerplot1 = figure('Name', 'Fehlerplot der ersten Funktion');
plot1 = subplot(2,1,1); hold on
plot1det = subplot(2,1,2); hold on

fehlerplot2 = figure('Name', 'Fehlerplot der zweiten Funktion');
plot2 = subplot(2,1,1); hold on
plot2det = subplot(2,1,2); hold on

for j = 1:3
  w = omega(j);
  X = zeros(N*N,1);
  fehler1 = fehlervec(A,b1,X,w,tol,nmax);
  fehler2 = fehlervec(A,b2,X,w,tol,nmax);
  numit1  = length(fehler1);
  numit2  = length(fehler2);
  clear X
  
  x1 = [1:numit1];
  x2 = [1:numit2];
  
  plot(plot1,    x1, fehler1);   hold on
  plot(plot1det, x1, fehler1);   hold on
  plot(plot2,    x2, fehler2);   hold on
  plot(plot2det, x2, fehler2);   hold on
endfor

% --- FEHLERPLOT ---
legend(plot1, ['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
title (plot1, 'relativer Fehler im SOR-Iterationsverfahren der ersten Funktion');
xlabel(plot1, 'Iterationszahl');
ylabel(plot1, 'relativer Fehler');
hold on

legend(plot1det, ['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
axis  (plot1det, [0 200 0 0.0001]);
title (plot1det, 'relativer Fehler im SOR-Iterationsverfahren (Detaildarstellung)');
xlabel(plot1det, 'Iterationszahl');
ylabel(plot1det, 'relativer Fehler');
hold on
print(fehlerplot1, '-dpng','fehlerplot1.png');


legend(plot2, ['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
title (plot2, 'relativer Fehler im SOR-Iterationsverfahren der zweiten Funktion');
xlabel(plot2, 'Iterationszahl');
ylabel(plot2, 'relativer Fehler');
hold on

legend(plot2det, ['w =',num2str(omega(1))],['w =',num2str(omega(2))], ['w =',num2str(omega(3))]);
axis  (plot2det, [0 200 0 0.0001]);
title (plot2det, 'relativer Fehler im SOR-Iterationsverfahren (Detaildarstellung)');
xlabel(plot2det, 'Iterationszahl');
ylabel(plot2det, 'relativer Fehler');
hold on
print(fehlerplot2, '-dpng','fehlerplot2.png');
