function y = f2 (x)
  x1 = x(1);
  x2 = x(2);
  y(1,1) = cos(x1) * cos(x2);
  y(1,2) = -1 * sin(x1) * sin(x2);
  y(2,1) = 2*x1;
  y(2,2) = 2*x2;
endfunction
