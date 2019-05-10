function sol = invtest(N)
  w = 1;
  disp(['===============']);
  tic
  disp(['A erstellen dauert...']);
  A = funA(N);
  toc
  
  N = N*N;
  
%  L = A(:,1:2);                    %L sparse  
%  D = A(:,3);     
  tic
  disp(['B erstellen dauert...']);
  %B(:,1:2) = A(:,1:2);
  A(:,3) = (1/w) .* A(:,3);
  A = A(:,1:3);
  toc

  
  tic 
  disp(['B sparsen dauert...']);
%  B = zeros(N,N);
  B = spdiags(A,[-sqrt(N),-1,0], N, N);
%  B = sparse(B);
  toc
%  size(B)
  tic
  disp(['B invertieren dauert...']);
  Binv = B \ speye(N);
  toc  
  
%  size(Binv)
  
  disp(['===============']);
endfunction
