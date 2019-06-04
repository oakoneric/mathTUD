function b = funb2(N)
  
  h = 1/(N+1);
  
  function y = pos(i,j)
    y = (i*h)^2 *(1-i*h)*(j*h)*(1-j*h);
  endfunction
    
  for i = 1:N                 %5-Punkt Annaeherung
    for j = 1:N
%      b((i-1)*N+j) = -(pos(j+1,i)-4*pos(j,i)+pos(j-1,i)+pos(j,i+1)+pos(j,i-1));
       b((i-1)*N+j) = (2*((j*h)^3 - (j*h)^2 + 3*(j*h)*((i*h) - 1)*(i*h) - ((i*h) - 1)*(i*h) )) * h*h ;
    endfor
  endfor
  b = transpose(b);
endfunction