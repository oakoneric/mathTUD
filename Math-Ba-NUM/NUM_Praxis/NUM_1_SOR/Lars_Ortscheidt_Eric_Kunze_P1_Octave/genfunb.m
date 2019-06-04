% Lars_Ortscheidt_Eric_Kunze_P1_Octave

function b = genfunb (N, f)
% input: N ... dimensionswurzel (nicht-quadrierte dimension)
%        f ... funktion (als function handle)

  h = 1/(N+1);
    
  for i = 1:N                   
    for j = 1:N
      b((i-1)*N+j)= f(j*h , i*h) * h*h;
    endfor
  endfor
  b = transpose(b);

endfunction
