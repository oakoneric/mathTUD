function y = f (x)
  x1   = x(1);
  x2   = x(2);
  y(1) = sin(x1) * cos(x2);
  y(2) = x1^2 + x2^2 -3;
  y    = transpose(y);
endfunction