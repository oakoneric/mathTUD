% Eric_Kunze_Johanna_Preusse_P1_Octave

function y = splineg3(N)
  % kubischer c1-spline der anderen funktion g
  % N ... feinheit, mit der Spline berechnet wird
  
  h=2/N;
  x=-1:h:1;
  
  M = 10*N;
  hM = 2/M;
  x0=-1:hM:1;
  
  j = 1;
  for i = 1:N
      d=g(x(i));
      c=g2(x(i));
      ab=[h*h*h h*h;3*h*h 2*h]\[g(x(i+1))-g(x(i))-g2(x(i))*h;g2(x(i+1))-g2(x(i))];
      a=ab(1);
      b=ab(2);
    for k=1:10
      y(j)=d+c*(x0(j)-x(i))+b*(x0(j)-x(i))^2+a*(x0(j)-x(i))^3;
      j = j + 1;
    end
  end
  y(j) = g(x(N+1));
end 
  
% folgende Implementierungen sind fuer allgemeinere Faelle unabhaengiges M
% aendere funktionsdefinition auf y=splineg3(x0,N)

% straight forward - aber langsam

% for j=1:length(x0)
%     for i=0:N-1
%         d(i+1)=g(x(i+1));
%         c(i+1)=g2(x(i+1));
%         ab=[h*h*h h*h;3*h*h 2*h]\[g(x(i+2))-g(x(i+1))-g2(x(i+1))*h;g2(x(i+2))-g2(x(i+1))];
%         a(i+1)=ab(1);
%         b(i+1)=ab(2);
%         if x0(j)>=-1+i*h
%             if x0(j)<=-1+(i+1)*h
%                 y(j)=d(i+1)+c(i+1)*(x0(j)-x(i+1))+b(i+1)*(x0(j)-x(i+1))^2+a(i+1)*(x0(j)-x(i+1))^3;
%             end
%         end
%     end
% end

% schnellere variante

%  i = 0;
%  j = 1;
%
%  while i <= N-1
%    if x0(j)>=-1+i*h && x0(j)<=-1+(i+1)*h
%      condition = true;
%      d=g(x(i+1));
%      c=g2(x(i+1));
%      ab=[h*h*h h*h;3*h*h 2*h]\[g(x(i+2))-g(x(i+1))-g2(x(i+1))*h;g2(x(i+2))-g2(x(i+1))];
%      a=ab(1);
%      b=ab(2);
%      while condition
%        y(j)=d+c*(x0(j)-x(i+1))+b*(x0(j)-x(i+1))^2+a*(x0(j)-x(i+1))^3;
%        j = j + 1;
%        condition = j <= length(x0) && x0(j)<=-1+(i+1)*h;
%      end
%    end 
%    i = i + 1;
%  end