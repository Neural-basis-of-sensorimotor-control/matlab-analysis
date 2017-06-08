function clone_plot(h_plot)

h_new_plot = plot(get(h_plot, 'XData'), get(h_plot, 'YData'));

props = get(h_plot);
fields = fieldnames(props);

for i=1:length(fields)
  
  switch fields{i}
    case {'Parent', 'XData', 'YData', 'BeingDeleted', 'BusyAction', 'Type', ...
        'Annotation'}
    otherwise
      set(h_new_plot, fields{i}, get(h_plot, fields{i}));
  end
  
end

  

