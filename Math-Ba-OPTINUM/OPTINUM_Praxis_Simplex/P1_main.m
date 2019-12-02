clear all
close all
%[zopt,xopt,ie] = simplex_Kunze_Eric_Ortscheidt_Lars(A,b,c)

%A=[1,2,1,0;4,1,0,1];b=[6;10];c=[-1;-1;0;0];  %Test aus Vorlesung [klappt]

%A=[1,-2,-1,1,0,0;2,-5,-1,0,1,0;1,-3,-1,0,0,1];b=[2;4;1];c=[-13;37;12;0;0;0];  %Test aus NUME [klappt]

%A=[2,-3,1,-1,0,0;1,-2,-1,0,-1,0;3,-5,0,0,0,-1];b=[3;1;4];c=[1;-1;2;0;0;0];  %Test NUME [Probleme]

%A=[-1,2,1,0,0;2,2,0,1,0;1,-4,0,0,1],b=[4;1;4],c=[-2;1;0;0;0]; %Test aus Übung [klappt]

A=[2,-1,1,0,0;1,-3,0,1,0;1,0,0,0,1], b=[10;15;4], c=[1;-3;0;0;0]; %Test aus Übung [klappt]

%A = [4,1,-1,1,0 ; 1,1,-3,0,1 ; -1,2,-2,0,0]; b = [5;3;1]; c=[-1,-2,3,0,0]'; %Test aus Übung mit HZF [klappt]

%A = [1,-1,0,1 ; -1,1,-1,0 ; -2,0,1,1]; b = [2,3,1]',c=[1,1,1,1]';
%A = [1,-1,0,1 ; 1,-1,1,0 ; 2,0,-1,-1 ; -1,-1,1,2], b = [2,-3,-1,3]', c=[1,1,1,1]';

%A = [1,-1,-1,0 ; 2,0,-1,2 ; 3,-1,-2,-2 ; 4,2,-1,-1]; b = [-1,-1,2,6]'; c = [1,1,1,1]'
%A = [1,-1,-1,0 ; 2,0,-1,2 ; 4,2,-1,-1]; b = [-1,-1,6]'; c = [1,1,1,1]';
%A = [-1,1,1,0 ; -2,0,1,-2 ; 4,2,-1,-1]; b = [1,1,6]'; c = [1,1,1,1]';

if (rank(A) < min(size(A))) 
  % nicht Vollrang
  print('nicht vollrang');
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
b   = -pos .* b + (ones(size(b)) - pos) .* b
pos =  pos * ones(1,size(A,2));
A   = -pos .* A + (ones(size(A)) - pos) .* A

%---------------------------------------------------------------
%phase 1

N = 1:size(A,2);
B = (size(A,2) + 1) : (size(A,2) + length(b));
%e = [ zeros(size(A,2)) ; ones(size(b)) ];

%for i=1:length(A(1,:))
%  N(i)=i;
%  e(i)=0;
%endfor
%for i=1:length(b)
%  B(i)= length(A(1,:))+i;
%  e(length(A(1,:))+i)=1;
%endfor
%e=e';



%erste basislösung nach (3.9)
P   = -A;
p   =  b;
q   = - ones(size(b))' * A;
q_0 =   ones(size(b))' * b;

print_tableau(0,N,B,P,p,q,q_0);

%q   = -e( length(A(1,:)) +1 : length(A(1,:))+length(b) )' * A
%q_0 =  e( length(A(1,:)) +1 : length(A(1,:))+length(b) )' * b

%----------------------------------------------
%schleife für tableaudurchläufe

while(min(q) < 0) %prüfen ob optimal
  
  %schritt 2
  [q_tau, tau] = min(min(q,[],1));  %tau bzgl P
  tau
%-------------------------------------------------
  %schritt 3
  if(min(P(:,tau)) >= 0)      %prüfen ob unbegrenzt
    ie=-2
    break;
  endif
  
%-----------------------------------------------------
  %schritt 4
  
  quot = -p ./ P(:,tau)
  quot((quot < 0)) = inf;
  [egal, sigm] = min(min(quot,[],1));
  sigm
  
  break
  
%  r=1;
%  for i=1:length(B)
%    if (P(i,tau)<0)
%      pivotspalte(r) = -p(i)/P(i,tau);
%      r=r+1;
%    endif
%  endfor
%  pivot = min(pivotspalte);      %pivotelement
%  pivotspalte
%  for i=1:length(B)
%    if(P(i,tau)<0)
%      if((-p(i)/P(i,tau))==pivot)      
%        sigm = i
%        break     %sigma bzgl P
%      endif
%    endif
%  endfor
%  clear pivotspalte

%-----------------------------------------------
  %austauschschritt
  
  %pivotelement
  Pneu(sigm,tau) = 1 / P(sigm,tau);               
             
  % pivotspalte
  qneu(tau) = q(tau) / P(sigm,tau); 
  for i=1:length(B)                             
    if(i ~= sigm)
      Pneu(i,tau) = P(i,tau) / P(sigm, tau);
    endif
  endfor
  
  % pivotzeile  
  pneu(sigm) = - p(sigm) / P(sigm, tau);
  for j=1:length(N)
    if(j~=tau)
      Pneu(sigm,j) = -P(sigm,j)/P(sigm, tau);
    endif
  endfor
  
  % rest 
  q_0 = q_0+ pneu(sigm)*q(tau);
  for i=1:length(B) 
    for j=1:length(N)
      if(i~=sigm)
        if(j~=tau)
          Pneu(i,j) = P(i,j) + Pneu(sigm,j) * P(i, tau);
          pneu(i)   = p(i)   + pneu(sigm)   * P(i, tau);
          qneu(j)   = q(j)   + Pneu(sigm,j) * q(tau);
        endif
      endif
    endfor
  endfor

  % sigma-tau-wechsel
  hilf = B(sigm);                                
  B(sigm)=N(tau);
  N(tau)=hilf;
  
  P = Pneu;
  p = pneu;
  q = qneu;
endwhile

%--------------------------------------------------

if(min(q)>= 0)     % falls system optimale lösung besitzt wird lösung gespeichert
  ie = 0;
  disp(['***********Loesungsmenge nicht leer**********']);
  for i=1:length(B)
    xopt_hilfe(B(i))= p(i);
  endfor
  for i=1:length(N)
    xopt_hilfe(N(i))=0;
  endfor
  xopt_hilfe = xopt_hilfe'
endif


%--------------------------------------------------
%phase 2
if(abs(q_0) > 0.01 )   %falls ursprungssystem leere lösungsmenge hat
  ie= -1
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
  
 [zopt2,xopt2,ie]=simplex(A,b,c,Bneu,Nneu)
endif
