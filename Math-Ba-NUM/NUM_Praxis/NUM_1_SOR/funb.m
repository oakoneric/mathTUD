function b = funb(N)
  
  h = 1/(N+1);
  
  function y = dir(i,j)
    y= sin(pi*i*h)*sin(pi*j*h);
  endfunction
    
  for i = 1:N                    %5-Punkt Stern Annaeherung
    for j = 1:N
%     b((i-1)*N+j)= sin(pi*j*h)*sin(pi*i*h)*h^2;
      b((i-1)*N+j)= -(dir(j+1,i)-4*dir(j,i)+dir(j-1,i)+dir(j,i+1)+dir(j,i-1));
    endfor
  endfor
  b = transpose(b);
endfunction
