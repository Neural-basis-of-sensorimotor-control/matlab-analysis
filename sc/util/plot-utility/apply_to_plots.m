function apply_to_plots(h_plots, fcn, varargin)

h_plots = get_plots(h_plots);

for i=1:length(h_plots)
  
  if get_nbr_of_samples(h_plots(i)) > 2
    fcn(h_plots(i), varargin{:});
  end
  
end

end
  