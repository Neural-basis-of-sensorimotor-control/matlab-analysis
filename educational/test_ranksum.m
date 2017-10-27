clear

for i=1:10
  
  n1 = 32;
  n2 = 12;

  a = rand(n1, 1);
  b = rand(n2, 1) + .1;

  p = ranksum(a, b);
  
  fprintf('%f\n', p);
  
end
