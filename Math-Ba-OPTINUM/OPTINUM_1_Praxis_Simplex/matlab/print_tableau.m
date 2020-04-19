function stat = print_tableau (t,N,B,P,p,q,q0)

  fprintf('\n|%3s', "====||");
  for i = 1 : length(N)
    fprintf('%6s', "========|");
  end
  fprintf('|========|\n');
  
  fprintf('| T%i ||',t);
  for i = 1 : length(N)
    fprintf(' x%-5i |', N(i));
  end
  fprintf('| %6i |\n', 1);
  
  fprintf('|%3s', "====||");
  for i = 1 : length(N)
    fprintf('%6s', "========|");
  end
  fprintf('|========|\n');
  
  for i = 1 : length(B)
    fprintf('| x%i ||',B(i));
    for j = 1 : length(N)
      fprintf(' %6.3f |', P(i,j));
    end
    fprintf('| %6.3f |\n', p(i));
  end
  
  fprintf('|%3s', "====||");
  for i = 1 : length(N)
    fprintf('%6s', "========|");
  end
  fprintf('|========|\n');
  
  fprintf('| z= ||');
  for i = 1 : length(N)
    fprintf(' %6.3f |', q(i));
  end
  fprintf('| %6.3f |\n', q0);
  
  fprintf('|%3s', "====||");
  for i = 1 : length(N)
    fprintf('%6s', "========|");
  end
  fprintf('|========|\n\n');
  
  % fprintf('\nDie erste Zahl %6.3f geteilt durch die zweite Zahl %6.3f ergibt %6.3f:\n',a,b,a/b);
end