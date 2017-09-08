function output = vectorize_fcn(fcn, varargin)

input = varargin{1};

if nargout>1
  error('Maximum one output argument allowed');
end

if nargout==1
  output = cell(size(input));
end

for i=1:length(input)
  
  debug_printout(char(fcn), i, length(input));
  
  tmp_input = input(i);
  
  if iscell(tmp_input)
    tmp_input = tmp_input{:};
  end
  
  if nargout
    output(i) = {fcn(tmp_input, varargin{2:end})};
  else
    fcn(tmp_input, varargin{2:end});
  end
  
end

if nargout>0
  output = cell2mat(output);
end

end