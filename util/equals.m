function val = equals(x1, x2)
%val = equals(x1, x2)
% x1 is a singular value or an array
% x2 is a singular value
% x1 and x2 may contain values that are numeric, characters or objects

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
elseif isobject(x2)
  if iscell(x1)
    val = cellfun(@(x) x == x2, x1);
  else
    val = x1 == x2;
  end
else
  error('equals not implemented for %s', class(x2));
end

end