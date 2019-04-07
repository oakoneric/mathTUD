function res = func (value)
  x = value(1);
  y = value(2);
  
%  res(1) = y*y + 8*y + x*x - 20*x;
%  res(2) = y*y - 4*y + 10*x*x - 12;
  
%  res(1) = y*y + 2*y + x*x - 14*x + 34;
%  res(2) = y*y + 2*y - x   + 4;

%  res(1) = y*y - 10*y + x*x - 16*x + 80;
%  res(2) = y*y - 10*y - x + 30;
  
  res(1) = y*y + 24*y + x*x + 20*x;
  res(2) = 30*x*x + y*y -12*y - 108;
  
  res = transpose(res);
endfunction
