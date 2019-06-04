% Lars_Ortscheidt_Eric_Kunze_P1_Octave

function A = funA(N)
  % N  steht für nicht-quadrierte dimension
    
  A(:,1) = -1 .* ones(N*N,1);
  A(:,3) =  4 .* ones(N*N,1);
  A(:,5) = -1 .* ones(N*N,1);
  
  A(:,2) = -1 .* ones(N*N,1);
  zeropos = 0:N:N*N;
  zeropos = zeropos(2:N+1);
  A(zeropos,2) = 0;
  
  A(:,4) = -1 .* ones(N*N,1);
  zeropos = 1:N:N*N;
  A(zeropos,4) = 0;
  
  A = sparse(A);

  % umwandlung von A in gesparste Matrixform
  A = spdiags(A, [-N,-1,0,1,N], N^2, N^2);
endfunction

% BACKUP
% ======
%for i=1:N^2
%  A(i,1)= -1;
%  A(i,3)= 4;
%  A(i,5)= -1;
%  if (mod(i,N) ~= 0)
%    A(i,2)= -1;
%  endif
%  if (mod(i-1,N) ~= 0)
%    A(i,4)= -1;
%endfor
%  endif
%A = full(spdiags(A, [-N,-1,0,1,N], N^2, N^2));