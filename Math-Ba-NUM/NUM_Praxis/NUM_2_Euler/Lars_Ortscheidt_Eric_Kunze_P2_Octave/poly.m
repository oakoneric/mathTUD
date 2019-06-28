% Lars Ortscheidt Eric Kunze P2 Octave
function y = poly(fun,h,a,b,y0)
  
  n    = (b-a)/h; % Anzahl der Schritte
  y(1) = y0;      % Anfangswert
  
  for i = 1:n
    y(i+1) = y(i) + h/2 * (fun(a+(i)*h , y(i)) + fun(a+(i+1)*h , y(i)+h*fun(a+(i)*h , y(i))));
  endfor
  
endfunction