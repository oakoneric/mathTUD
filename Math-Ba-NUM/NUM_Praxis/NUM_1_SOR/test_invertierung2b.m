  
  
  N=input('Geben Sie N ein! ')
  
  
  L=[];
  R=[];
  
  hilf1 = sparse(zeros(N*N,2));
  hilf1(1:N*N-N,1) = -1*ones(1,N*N-N); 
  
  hilf1(:,2) = -1*ones(1,N*N);    #Füllt Spalte 2 mit -1-en
  hilf1(N:N:N*N,2) = 0;           #Ersetzt jeden N-ten Eintrag durch eine 0 
  
  hilf2 = sparse(zeros(N*N,2));
  hilf2(2:N*N,1) = -1*ones(1,N*N-1);    #Füllt die 4. Spalte ab dem 2. mit -1-en
  hilf2(N+1:N:N*N,1) = 0;           #Ersetzt jeden N-ten eintrag ab dem 2. mit einer 0
  
  hilf2(N:N*N,2) = -1*ones(1,N*N-N+1);
  
  
  L = spdiags(hilf1,[-N,-1],sparse(zeros(N*N)));
  R = spdiags(hilf2,[1,N],  sparse(zeros(N*N)));
  
  clear hilf1
  clear hilf2
  clear R

  tic
  inverse = (L+4*eye(N*N)) \ speye(N*N);
  toc
  
  
%#_______________________________________________________________________________
%  
%  q=[];
%  A=[];
%  t2=clock();
%  for j= 1: N
%
%    q(j) = (1/4)^(j); #Nebendiagonalen (i+j-2)*1/a^(i+j-1)        
%      
%  endfor  
%
%
%  vec = zeros( 1, N );  #Dient nur dazu, im toeplitz-Befehl den diagonal conflict zu vermeiden.
%  vec(1) = 1/4;
%  B=sparse(toeplitz ( q , vec ) );
%  Z=B;
%
%
%  A=B;
%  for k=2:N
%  A = blkdiag (A, B ) ;
%  endfor
%
%  
%  for i= 2: N
%    hilf=[];
%    
%    Z=sparse(Z*B);
%    
%    for k=1:((N-i)+1)
%      hilf = blkdiag (hilf, Z )  ;
%    endfor  #Speichert die Blöcke der Inversen auf den entsprechenden Diagonalen A^(-i)
%    
%      A(N*(i-1)+1:N*N,1:N*(N-i+1)) = sparse(A(N*(i-1)+1:N*N,1:N*(N-i+1)) + hilf);
%  endfor  
%  timer=etime(clock(),t2)

