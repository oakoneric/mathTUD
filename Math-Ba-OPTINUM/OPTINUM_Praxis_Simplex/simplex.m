function [zopt,xopt,ie]=simplex(A,b,c,B,N)

ie=5;   %falls ie nicht definiert wird

for i= 1:length(B)                %A_B
  for j = 1:rows(A)
    A_B(j,i) = A(j,B(i));
  endfor
endfor

for i= 1:length(N)                %A_N
  for j = 1:rows(A)
    A_N(j,i) = A(j,N(i));
  endfor
endfor

A_b_inv = inverse(A_B);

%c_N
for i=1:length(N)
  c_N(i) = c(N(i));
endfor
c_N=c_N';
%c_B
for i=1:length(B)
  c_B(i) = c(B(i));
endfor
c_B=c_B';
%P
P = -A_b_inv * A_N;
%p
p = A_b_inv * b;
%q
q = c_N' + (transpose(c_B) * P);
%q_0
q_0 = c_B' * p;

%----------------------------------------------
%schleife
tableauanzahl=1

while(and(min(q) < 0, min(p)>=0)) %prüfen ob optimal

  %schritt 2
  [q_tau, tau] = min(min(q,[],1));  %tau bzgl P
  tau;
%-------------------------------------------------
  %schritt 3
  if(min(P(:,tau)) >= 0)      %prüfen ob unbegrenzt
    ie=-2
    break;
  endif
  
%-----------------------------------------------------
  %schritt 4
  r=1;
  for i=1:length(B)
    if (P(i,tau)<0)
      pivotspalte(r) = -p(i)/P(i,tau);
      r=r+1;
    endif
  endfor
  pivot = min(pivotspalte);      %pivotelement
  pivotspalte;
  for i=1:length(B)
    if(P(i,tau)<0)
      if((-p(i)/P(i,tau))==pivot)      
        sigm = i;
        break      %sigma bzgl P
      endif
    endif
  endfor
  clear pivotspalte
  
%-----------------------------------------------
  %austauschschritt
  Pneu(sigm,tau) = 1/P(sigm,tau);               %pivotelement
   
  qneu(tau) = q(tau)/P(sigm, tau);               %pivotspalte
  for i=1:length(B)                             
    if(i~=sigm)
      Pneu(i,tau) = P(i,tau)/P(sigm, tau);
    endif
  endfor
  
  pneu(sigm) = -p(sigm)/P(sigm, tau);           %pivotzeile
  for j=1:length(N)
    if(j~=tau)
      Pneu(sigm,j) = -P(sigm,j)/P(sigm, tau);
    endif
  endfor
  
  q_0 = q_0+ pneu(sigm)*q(tau);
  for i=1:length(B)                                 %andere 
    for j=1:length(N)
      if(i~=sigm)
        if(j~=tau)                                                                    %restliche
          Pneu(i,j) = P(i,j) + Pneu(sigm,j)*P(i, tau);
          pneu(i) = p(i)+ pneu(sigm) * P(i, tau);
          qneu(j) = q(j) + Pneu(sigm,j)*q(tau);
        endif
      endif
    endfor
  endfor

  hilf = B(sigm);                                %sigma-tau-wechsel
  B(sigm)=N(tau);
  N(tau)=hilf;
  P=Pneu;
  p=pneu;
  q=qneu;
  tableauanzahl=tableauanzahl+1
  
endwhile

%--------------------------------------------------

if(min(q)>= 0)
  ie = 0;
  for i=1:length(B)
    xopt(B(i))= p(i);
  endfor
  for i=1:length(N)
    xopt(N(i))=0;
  endfor
  xopt=xopt';
  zopt= c' * xopt;
else % unbeschränkt
  xopt=42;
  zopt=-inf;
endif

%if(min(p)<0) % unzulässig
%  xopt=nan;
%  zopt=nan;
%endif

endfunction