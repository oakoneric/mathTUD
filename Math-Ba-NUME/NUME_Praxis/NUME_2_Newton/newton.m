function y = newton (x, func, jacobi, nmax, gedaempft, delta, rho, tol, exakt)
  % x ... startwert
  % func ... funktionsname (als string)
  % javobi ... name der ableitung (als String)
  % nmax ... anzahl der newton schritte
  % gedaempft ... auswahl ob gedaempftes oder ungedaempftes newton verfahren (1/true = gedaempft)
  % delta 
  % rho
  % tol ... abbruchparameterf  = str2func(func);
  
  f  = str2func(func);
  Df = str2func(jacobi);
  
  file = fopen('doc.txt', 'w');
  
  fprintf(file,'%s\r\n','---------------------------------------------------------------------------------------------');
  fprintf(file,'Eingabedaten: \r\n');
  fprintf(file,'%s\r\n','---------------------------------------------------------------------------------------------');
  
  fprintf(file,'Startwert    : [ %16.11f , %16.11f ] \r\n', x(1), x(2));
  fprintf(file,'nmax         :   %16.11f\r\n', nmax);
  fprintf(file,'delta        :   %16.11f\r\n', delta);
  fprintf(file,'rho          :   %16.11f\r\n', rho);
  fprintf(file,'Toleranzwert :   %16.11f\r\n', tol);
  fprintf(file,'exakter Wert : [ %16.11f , %16.11f ] \r\n', exakt(1), exakt(2));
  fprintf(file, '.\r\n');
  fprintf(file,'%s\r\n','---------------------------------------------------------------------------------------------');
  fprintf(file,'%3s | %17s | %17s | %13s | %13s | %13s\r\n','c','xn(1)', 'xn(2)','xn - x*','f(xn)', 'alpha');
  fprintf(file,'%s\r\n','---------------------------------------------------------------------------------------------');
  
  counter = 0;
  gamma = rho;
  alph = 1;
  do
    xalt = x;
    DELTA = Df(xalt) \ (-f(xalt));
  
    alph = min( 1 , alph / rho );
    while ( norm(f(x + alph * DELTA))^2 > (1 - gamma * alph) * norm(f(x))^2 )
      alph = rho * alph;
    endwhile
    
    x = xalt + alph * DELTA;
    ++counter;
    
    % fehler berechnen
    fehler = norm(x - exakt);
    defekt = norm(f(x));
    
    % dokumentation
    fprintf(file,'%3u | %17.11f | %17.11f | %13.11f | %13.11f | %13.11f \r\n', counter, x(1), x(2) , fehler, defekt, alph);
    
    %fprintf(file,'%6s %12s\n','x','exp(x)');
    %fprintf(file,'%6.2f %12.8f\n',A);
  until ( ( min( norm(x-xalt) , norm(f(x)) ) <= tol ) || ( counter >= nmax ) )   
    
    fclose(file);
    disp(['Folgende Nullstelle wurde gefunden: xN = [ ', num2str(x(1)), ' , ', num2str(x(2)), ' ]']);
endfunction
