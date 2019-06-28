% Lars Ortscheidt Eric Kunze P2 Octave
function y = im_euler(fun,h,a,b,y0, beta)
  n      = (b-a)/h;  % Anzahl der Schritte
  y(1)   = y0;       % Anfangswert
  phalbe = (1-h*beta)/(2*h*beta); % p/2 in p-q-Formel
  for i = 1:n
    % Herleitung fuer AWP (1) mit pq Formel
    y(i+1) = -phalbe + sqrt((phalbe^2 + y(i)/(h*beta)));
  endfor
endfunction