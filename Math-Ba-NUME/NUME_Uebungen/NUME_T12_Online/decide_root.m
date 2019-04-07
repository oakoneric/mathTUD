function y = decide_root (val)
  
  if ( all( [0;0] == func(val) ) ) %func(val) has to be a column vector
    if det( deriv(val) ) != 0
      y = "regular root";
    else
      y = "root which is not regular";
    endif
  else
    y = "no root";
  endif
endfunction
