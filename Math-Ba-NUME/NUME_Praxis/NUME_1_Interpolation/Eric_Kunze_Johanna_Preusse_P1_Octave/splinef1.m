% Eric_Kunze_Johanna_Preusse_P1_Octave

function y = splinef1(N)
  % linearer spline der runge funktion
  % N ... feinheit, mit der Spline berechnet wird

  h=2/N;
  x=-1:h:1;

  M = 10*N;
  hM = 2/M;
  x0=-1:hM:1;

  j = 1;
  for i = 1:N
    for k=1:10
      y(j) = ( ( f(x(i+1)) - f(x(i)) ) / h ) * (x0(j) - x(i)) + f(x(i));
      j = j + 1;
    end
  end
  y(j) = f(x(N+1));
end

% folgende Implementierungen sind fuer allgemeinere Faelle unabhaengiges M
% aendere funktionsdefinition auf y=splinef1(x0,N)

%i = 1;
%j = 1;
%while i <= N-1
% if j <= length(x0) && x0(j)>=-1+i*h && x0(j)<=-1+(i+1)*h
%   condition = true;
%   while condition
%     y(j) = f(x(i)) + (f2(x(i))) *(x0(j)-x(i));
%     j = j + 1;
%     condition = j <= length(x0) && x0(j)<=-1+(i+1)*h;
%   end
% end 
% i = i + 1;
%end

%aussere schleife evaluiert jeden punkt des eingabevektors x0
%innere schleife geht spline-abschnitte durch
%for j=1:length(x0)
%    for i=1:N
%        % if schleife entscheidet, in welchem spline-abschnitt x0 liegt
%        if x0(j)>=-1+(i-1)*h && x0(j)<=-1+(i)*h
%                y(j) = f(x(i)) + (f(x(i+1))-f(x(i))) / h.*(x0(j)-x(i));
%        end
%    end
%end