function close_request(obj)


if obj.has_unsaved_changes
  
  error('Not implemented yet')
  
else
  
  delete(obj.plot_window);

end

end