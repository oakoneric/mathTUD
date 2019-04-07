function res = newtonstep (start)
  % start should be a coloumn vector
  A =     deriv(start);
  b = -1 * func(start);
  x = A\b;
  res = x .+ start;
endfunction
