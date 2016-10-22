function m1 = alignmatrix(m1, m2)

if size(m1,1) ~= size(m2,1)
  m1 = m1';
end

if size(m1, 1) ~= size(m2,1) || size(m1, 2) ~= size(m2, 2)
  error('Matrices are incosistent');
end
