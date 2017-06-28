function intra_from_debug_to_release_tick_label(ax)

if isfigure(ax)
  
  for i=1:length(ax)
    
    fprintf('%d (%d)\n', i, length(ax));
    intra_from_debug_to_release_tick_label(get_axes(ax(i)));
    
    h_legend = get_legend(ax(i));
    
    if ~isempty(h_legend)
    
      values = get(h_legend, 'String');
      set(h_legend, 'String', intra_formalize_tick_labels(values));
    
    end
    
  end
  
else
  
  for i=1:length(ax)
    fprintf('\t ... %d ', i);
    
    xticklabel = get(ax(i), 'XTickLabel');
    yticklabel = get(ax(i), 'YTickLabel');
    
    set(ax(i), 'XTickLabel', intra_formalize_tick_labels(xticklabel), ...
      'YTickLabel', intra_formalize_tick_labels(yticklabel));
    
  end
  
  fprintf('\n')
end

end