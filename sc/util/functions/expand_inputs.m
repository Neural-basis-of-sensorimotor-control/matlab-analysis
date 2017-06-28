function varargout = expand_inputs(s, varargin)

varargout = cell(size(varargin));

for i=1:length(varargin)
  
  varargout(i) = {s.(varargin{i})};
  
end

end