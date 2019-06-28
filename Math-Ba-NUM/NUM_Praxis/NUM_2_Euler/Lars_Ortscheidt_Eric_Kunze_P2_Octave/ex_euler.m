% Lars Ortscheidt Eric Kunze P2 Octave
function y = ex_euler(fun,h,a,b,y0)  
  n    = (b-a)/h; % Anzahl der Schritte
  y(1) = y0;      % Anfangswert  
  for i = 1:n
    y(i+1) =  y(i) + h * fun( a + i*h , y(i) );
  endfor
endfunction
