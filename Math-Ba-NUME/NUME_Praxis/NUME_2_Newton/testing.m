function y = testing(func, val)
  x = 0
  file=fopen('test.txt', 'wt');
  fprintf(file,'%6s %12s\n','x','exp(x)');
  while x <=10
    A = [x; exp(x)];
    fprintf(file,'%6.2f %12.8f\n',A);
    ++x
  endwhile
  fprintf(file, 'Hier ist jetzt schluss.');
  fclose(file);
endfunction