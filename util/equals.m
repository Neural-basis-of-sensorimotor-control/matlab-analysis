function val = equals(x1, x2)

if isnumeric(x2)
  if iscell(x1)
    val = cellfun(@(x) x == x2, x1);
  else
    val = x1 == x2;
  end
elseif ischar(x2)
  if iscell(x1)
    val = cellfun(@(x) strcmp(x, x2), x1);
  else
    val = strcmp(x1, x2);
  end
  
else
  error('equals not implemented for %s', class(x2));
end

end