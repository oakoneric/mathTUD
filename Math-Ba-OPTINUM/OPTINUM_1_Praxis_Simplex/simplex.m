function [zopt,xopt,ie,B,N]=simplex(P,p,q,q_0,B,N)

%----------------------------------------------
%schleife
tableauanzahl = 0;
print_tableau(tableauanzahl,N,B,P,p,q,q_0);
while(min(q) < 0) %prüfen ob optimal

  %schritt 2
  [q_tau, tau] = min(q);  %tau bzgl P
  tau
%-------------------------------------------------
  %schritt 3
  if(min(P(:,tau)) >= 0)      %pruefen ob unbegrenzt
    ie=-2;
    break;
  endif
  
%-----------------------------------------------------
  %schritt 4
  quot = -p ./ P(:,tau);
  quot((P(:,tau) >= 0)) = inf;
  [egal, sigm] = min(quot);
  sigm

  
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
        if(j~=tau)
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
  p=pneu';
  q=qneu;
  tableauanzahl=tableauanzahl+1;
  print_tableau(tableauanzahl,N,B,P,p,q,q_0);
  
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
  zopt= q_0;
else % unbeschraenkt
  ie = -2;
  xopt=42;
  zopt=-inf;
endif

endfunction
