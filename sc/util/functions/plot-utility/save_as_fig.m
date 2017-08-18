function save_as_fig(fig)

if ~nargin
  fig = gcf;
end

if length(fig) ~= 1
  
  vectorize_fcn(@save_as_fig, fig);
  return
  
end

update_fig_name(fig, 'fig');
savefig(fig, fig.FileName);

end
