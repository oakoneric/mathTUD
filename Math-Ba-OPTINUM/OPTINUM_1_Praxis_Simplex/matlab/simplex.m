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
  end
  
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
    end
  end
  
  pneu(sigm) = -p(sigm)/P(sigm, tau);           %pivotzeile
  for j=1:length(N)
    if(j~=tau)
      Pneu(sigm,j) = -P(sigm,j)/P(sigm, tau);
    end
  end
  
  q_0 = q_0+ pneu(sigm)*q(tau);
  for i=1:length(B)                                 %andere 
    for j=1:length(N)
      if(i~=sigm)
        if(j~=tau)
          Pneu(i,j) = P(i,j) + Pneu(sigm,j)*P(i, tau);
          pneu(i) = p(i)+ pneu(sigm) * P(i, tau);
          qneu(j) = q(j) + Pneu(sigm,j)*q(tau);
        end
      end
    end
  end

  hilf = B(sigm);                                %sigma-tau-wechsel
  B(sigm)=N(tau);
  N(tau)=hilf;
  P=Pneu;
  p=pneu';
  q=qneu;
  tableauanzahl=tableauanzahl+1;
  print_tableau(tableauanzahl,N,B,P,p,q,q_0);
  
end

%--------------------------------------------------

if(min(q)>= 0)
  ie = 0;
  for i=1:length(B)
    xopt(B(i))= p(i);
  end
  for i=1:length(N)
    xopt(N(i))=0;
  end
  xopt=xopt';
  zopt= q_0;
else % unbeschraenkt
  ie = -2;
  xopt=42;
  zopt=-inf;
end

end
