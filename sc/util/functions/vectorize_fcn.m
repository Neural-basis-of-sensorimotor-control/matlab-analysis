function output = vectorize_fcn(fcn, varargin)

input = varargin{1};

if nargout>1
  error('Maximum one output argument allowed');
end

if nargout==1
  output = cell(size(input));
end

for i=1:length(input)
  
  if get_debug_mode()
    fprintf('DEBUG: %s %d out of %d\n', char(fcn), i, length(input));
  end
  
  if nargout
    output(i) = {fcn(input(i), varargin{2:end})};
  else
    fcn(input(i), varargin{2:end});
  end
  
end

if nargout>0
  output = cell2mat(output);
end

end