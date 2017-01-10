function val = sc_get_filtered_property(object, property, varargin)

if length(object) > 1
  val = cell(size(object));
  
  for i=1:length(object)
    val(i) = sc_get_filtered_property(object(i), property, varargin{:});
  end
  
else
  val = object.(property);
  extra_filters = true(size(val));
  
  for i=1:length(varargin)
    property = varargin{i};
    if property(1) == '~'
      extra_filters = extra_filters & ~object.(property(2:end));
    else
      extra_filters = extra_filters & object.(property);
    end
  end
  
  val = {val(extra_filters)};

end