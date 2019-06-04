function b = funb(N)
  
  h = 1/(N+1);
     
  for i = 1:N                    %5-Punkt Stern Annaeherung
    for j = 1:N
     b((i-1)*N+j) = sin(pi*j*h)*sin(pi*i*h)*h*h;
%     b((i-1)*N+j) = f  (j*h , i*h) * h^2;
    endfor
  endfor
  b = transpose(b);
endfunction
