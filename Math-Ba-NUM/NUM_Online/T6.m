clear all
pkg load symbolic

A = input('Enter matrix A: ');
b = input('Enter vector b: ');
x = input('Enter vector x_0: ');

if(rows(b)!=3 && columns(x)!=1)
  b = b.';
end
if(rows(x)!=3 && columns(x)!=1)
  x = x.';
end

d = sym(b - A*x);
r = d;

for k=1:2
  printf("%s. iteration:\n",num2str(k))
  t = norm(r)^2/(d.'*A*d);
  x = x + t*d
  r0 = r;
  r = r - t*A*d;
  d = r + norm(r)^2/norm(r0)^2*d;
end
