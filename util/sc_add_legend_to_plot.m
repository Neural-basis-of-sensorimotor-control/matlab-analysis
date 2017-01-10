function sc_add_legend_to_plot(plots, axeshandle)

if ~exist('axeshandle', 'var')
  axeshandle = gca;
end

tags = {plots.Tag};
unique_tags = unique(tags);
plothandles = plots(sc_str_find({plots.Tag}, unique_tags, 1));

for i=1:length(axeshandle)
  legend(axeshandle(i), plothandles, unique_tags{:});
end

end