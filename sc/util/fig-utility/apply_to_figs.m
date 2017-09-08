function apply_to_figs(figs, fcn, varargin)

if ~any(isfigure(figs))
  
  if nargin > 1
    varargin  = [{fcn} varargin];
  end
  
  fcn       = figs;
  figs      = get_all_figures();

end

for i=1:length(figs)
  
  fcn(figs(i), varargin{:});
  
end

end
  