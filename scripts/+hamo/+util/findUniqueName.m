function name = findUniqueName(nameSet, name, suffix)

if nargin<3
  suffix=1;
end

while any(strcmp(nameSet, sprintf('%s%d', name, suffix)))
  suffix = suffix+1;
end
name = sprintf('%s%d', name, suffix);

end