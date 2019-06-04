## Copyright (C) 2019 k-eri

function erg = prob (n, k)
  erg = 1;
  for i=1:(k-1)
    erg = erg * (n-i)/n;
  endfor
endfunction
