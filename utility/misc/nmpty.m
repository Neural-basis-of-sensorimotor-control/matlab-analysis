function val = nmpty(item, property)

if nargin < 2
  property = 'tag';
end

if isempty(item)
  val = [];
else
  val = item.(property);
end
  
end