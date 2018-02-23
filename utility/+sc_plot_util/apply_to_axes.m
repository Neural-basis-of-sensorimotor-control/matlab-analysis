function apply_to_axes(h_axes, fcn, varargin)

if ~any(isaxes(h_axes))
  
  if nargin > 1
    varargin  = [{fcn} varargin];
  end
  
  fcn    = h_axes;
  h_axes = get_axes(get_all_figures());

end

for i=1:length(h_axes)
  
  fcn(h_axes(i), varargin{:});
  
end

end
