function val = list_contains(list, property, value)

if nargin==2
  val = any(equals(list, property));
elseif nargin==3
  val = any(equals(get_values(list, property), value.(property)));
end

end