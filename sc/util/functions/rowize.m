function x = rowize(x)

dim = size(x);

if length(dim) > 2
  error('> 2 dimensions')
end

if isempty(dim == 1)
  error('No singular dimension');
end

if dim(1) == 1
  x = x';
end

end