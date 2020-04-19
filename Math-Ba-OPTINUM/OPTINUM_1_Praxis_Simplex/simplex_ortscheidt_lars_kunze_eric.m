function [zopt,xopt,ie]=simplex_ortscheidt_lars_kunze_eric(A,b,c)
    
  % erste Aufgabe: [loesung x = (2,5,0,5)]
  %A = [1,-1,0,1 ; 1,-1,1,0 ; 2,0,-1,-1 ; -1,-1,1,2]; b = [2,-3,-1,3]'; c=[1,1,1,1]'; 

  % zweite Aufgabe: [keine loesung, da leerer zielbereich]
  %A = [1,-1,-1,0 ; 2,0,-1,2 ; 3,-1,-2,-2 ; 4,2,-1,-1]; b = [-1,-1,2,6]'; c = [1,1,1,1]';


  if (rank(A) < min(size(A))) 
    % nicht vollrang - umwandlung in zeilenstufenform und streichen von nullzeilen
    disp(['***********Matrix hat nicht Vollrang**********']);
    big = [A b];
    big = rref(big);

    for i=size(big,1):-1:1
      if (big(i,:) == zeros(1,size(big,2)))
        big(i,:) = [];
      endif
    endfor
    
    b = big(:, size(big,2)  );
    A = big(:, 1:size(big,2)-1);
  endif

  %negative Zeilen umdrehen
  pos = (b < 0);
  b   = -pos .* b + (ones(size(b)) - pos) .* b;
  pos =  pos * ones(1,size(A,2));
  A   = -pos .* A + (ones(size(A)) - pos) .* A;


%---------------------------------------------------------------
% PHASE 1
%---------------------------------------------------------------

  disp(['=========================================']);
  disp(['               PHASE 1                   ']);
  disp(['=========================================']);


  N = 1:size(A,2);
  B = (size(A,2) + 1) : (size(A,2) + length(b));

  % erste basisloesung nach (3.9)
  P   = -A;
  p   =  b;
  q   = - ones(size(b))' * A;
  q_0 =   ones(size(b))' * b;

  [zopt_hilfe,xopt_hilfe,ie,B,N] = simplex(P,p,q,q_0,B,N);

%---------------------------------------------------------------
% PHASE 2
%---------------------------------------------------------------

  disp(['']);
  disp(['']);
  disp(['=========================================']);
  disp(['               PHASE 2                   ']);
  disp(['=========================================']);


  if(abs(zopt_hilfe) > 0.01 )   %falls ursprungssystem leere loesungsmenge hat
    ie= -1
    disp(['***********Loesungsmenge ist leer**********']);
  else
    n=1;
    for i=1:length(N)
      if(N(i) <= length(A(1,:)))
        Nneu(n)=N(i);
        n=n+1;
      endif 
    endfor
    
    n=1;
    for i=1:length(B)
      if(B(i) <= length(A(1,:)))
        Bneu(n)=B(i);
        n=n+1;
      endif 
    endfor
    
    B = Bneu;
    N = Nneu;
    
    ie=5;   %falls ie nicht definiert wird

    for i= 1:length(B)                %A_B
      for j = 1:rows(A)
        A_B(j,i) = A(j,B(i));
      endfor
    endfor

    for i= 1:length(N)                %A_N
      for j = 1:rows(A)
        A_N(:,i) = A(:,N(i));
      endfor
    endfor

    A_b_inv = inverse(A_B);

    %c_N
    for i=1:length(N)
      c_N(i) = c(N(i));
    endfor
    c_N = c_N';
    
    %c_B
    for i=1:length(B)
      c_B(i) = c(B(i));
    endfor
    c_B = c_B';
    
    P   = -A_b_inv * A_N;
    p   = A_b_inv * b;
    q   = c_N' + (transpose(c_B) * P);
    q_0 = c_B' * p;

   [zopt,xopt,ie,Bneu,Nneu] = simplex(P,p,q,q_0,Bneu,Nneu);

    if (ie == 0)
      disp(['***********optimale Loesung gefunden**********']);
      fprintf('Die optimale Loesung ist x = ');
      xopt
      fprintf('Der Zielfunktionswert betraegt z = %f \n', zopt);
    endif
    if (ie == -2)
      disp(['***********Loesungsmenge unbeschraenkt**********']);
    endif
  endif

endfunction
