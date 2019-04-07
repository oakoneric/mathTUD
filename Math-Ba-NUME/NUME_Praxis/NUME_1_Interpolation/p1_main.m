% Eric_Kunze_Johanna_Preusse_P1_Octave

clear all;
close all;
auswahl=0;

% deklaration der funktionen f (runge) und g
%f = @(x) 1./(1.+25.*x.^2);
%g = @(x) (1.+cos((3*pi/2).*x)).^(2/3);
%fehler = @(x,y) abs(x-y);
%
%% deklaration der ableitungen
%f2 = @(x) -50.*x ./ (1+50.*x.*x+625.*x.^4);
%g2 = @(x) -pi.*sin(1.5*pi.*x).*(1+cos(1.5*pi.*x)).^(-1/3);

while auswahl ~= 3
  auswahl = menu('Dieses Programm interpoliert versch. Funktionen.', ...
    'Runge-Funktion','f(x) = 1+cos((3*pi/2)*x))^(2/3)','Beenden');
  if(auswahl ~= 3)
    N=input('Eingabe der Feinheit N fuer die Plots: ');
    hN=2/N;

    % feinere zerlegung mit M
    M = 10*N;
    hM = 2/M;

    % feinere zerlegung fur plots
    x = -1:hM:1;
  end 
  switch auswahl
    case 1 % RUNGE-FUNKTION
      % plot fuer rungefunktion und interpolierende
      fplot = figure('Name', 'Runge-Funktion');
      plot(x, f(x), x, splinef1(N), x, splinef3(N))
      legend('Rungefunktion','linearer Spline','kubischer Spline')
      achse = axis();
      textpos_x = achse(1) + 0.1;
      textpos_y = achse(4) - 0.1;
      text(textpos_x,textpos_y, ['N=' num2str(N)])
      print(fplot,'-dpng','fplot.png');

      % fehlerplot fuer rungefunktion
      ffehlerplot = figure('Name', 'Interpolationsfehler der Runge-Funktion');
      plot(x,fehler(f(x),splinef1(N)), x, fehler(f(x),splinef3(N)))
      legend('Fehler des linearen Splines', 'Fehler des kubischen Splines')
      achse = axis();
      textpos_x = achse(1) + 0.1;
      textpos_y = achse(4) - 0.005;
      text(textpos_x,textpos_y, ['N=' num2str(N)])
      print(ffehlerplot, '-dpng','ffehlerplot.png');

      for i=0:11 %11
        n(i+1) = 4*2^i;
        hE = 2 / (10*n(i+1));
        xE = -1:hE:1;
        Ef1(i+1) = max( fehler( f(xE),splinef1(n(i+1)) ) );
        Ef3(i+1) = max( fehler( f(xE),splinef3(n(i+1)) ) );
      end
      for i=0:10 %10
            nenner = log(2/(4*2^i))-log(2/(4*2^(i+1)));
            EOCf1(i+1) = (log(Ef1(i+1))-log(Ef1(i+2))) / nenner;
            EOCf3(i+1) = (log(Ef3(i+1))-log(Ef3(i+2))) / nenner;
      end
      
      disp(['Maximaler Fehler fuer linearen Spline: ',num2str(Ef1)]);
      disp(['Maximaler Fehler fuer kubischen Spline: ',num2str(Ef3)]);
      disp(['Experimentelle Kovergenzordnung fuer linearen Spline: ',num2str(EOCf1)]);
      disp(['Experimentelle Kovergenzordnung fuer kubischen Spline: ',num2str(EOCf3)]);
    case 2 % ANDERE FUNKTION
      % plot fur andere funktion und interpolierende
      gplot = figure('Name', 'weitere Funktion');
      plot(x,g(x), x, splineg1(N), x, splineg3(N))
      legend('Funktion','linearer Spline','kubischer Spline')
      achse = axis();
      textpos_x = achse(1) + 0.1;
      textpos_y = achse(4) - 0.1;
      text(textpos_x,textpos_y, ['N=' num2str(N)])
      print(gplot,'-dpng','gplot.png');

      % fehlerplot fur andere funktion
      gfehlerplot = figure('Name', 'Interpolationsfehler einer weiteren Funktion');
      plot(x,fehler(g(x),splineg1(N)) , x,fehler(g(x),splineg3(N)))
      legend('Fehler des linearen Splines', 'Fehler des kubischen Splines')
      achse = axis();
      textpos_x = achse(1) + 0.1;
      textpos_y = achse(4) - 0.01;
      text(textpos_x,textpos_y, ['N=' num2str(N)])
      print(gfehlerplot, '-dpng','gfehlerplot.png');

      % Berechnung des maximalen Fehlers
      for i=0:11 %11
        n(i+1) = 4*2^i;
        hE = 2 / (10*n(i+1));
        xE = -1:hE:1;
        Eg1(i+1) = max( fehler( g(xE),splineg1(n(i+1)) ) );
        Eg3(i+1) = max( fehler( g(xE),splineg3(n(i+1)) ) );
      end
      for i=0:10 %10
        nenner = log(2/(4*2^i))-log(2/(4*2^(i+1)));
        EOCg1(i+1) = (log(Eg1(i+1))-log(Eg1(i+2))) / nenner;
        EOCg3(i+1) = (log(Eg3(i+1))-log(Eg3(i+2))) / nenner;
      end
      
      disp(['Maximaler Fehler fuer linearen Spline: ',num2str(Eg1)]);
      disp(['Maximaler Fehler fuer kubischen Spline: ',num2str(Eg3)]);
      disp(['Experimentelle Kovergenzordnung fuer linearen Spline: ',num2str(EOCg1)]);
      disp(['Experimentelle Kovergenzordnung fuer kubischen Spline: ',num2str(EOCg3)]);
   end %switch
  
  close all
end %while

clear all
close all

