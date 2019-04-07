function res = deriv (val)
  x = val(1);
  y = val(2);
  
%  res(1,1) = 2*x - 20;
%  res(1,2) = 2*y +  8;
%  res(2,1) = 20*x    ;
%  res(2,2) = 2*y -  4;
  
%  res(1,1) = 2*x - 14;
%  res(1,2) = 2*y +  2;
%  res(2,1) = -1;
%  res(2,2) = 2*y +  2;

%  res(1,1) = 2*x - 16;
%  res(1,2) = 2*y - 10;
%  res(2,1) = -1;
%  res(2,2) = 2*y - 10;

  res(1,1) = 2*x + 20;
  res(1,2) = 2*y + 24;
  res(2,1) = 60*x;
  res(2,2) = 2*y - 12;
 
endfunction
