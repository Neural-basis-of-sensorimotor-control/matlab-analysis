function apply_to_figs(h_figs, fcn, varargin)

if ~any(isfigure(h_figs))
  
  if nargin > 1
    varargin  = [{fcn} varargin];
  end
  
  fcn    = h_figs;
  h_figs = get_all_figures();

end

for i=1:length(h_figs)
  
  fcn(h_figs(i), varargin{:});
  
end

end
  