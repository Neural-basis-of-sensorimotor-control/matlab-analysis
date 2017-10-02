function sc_fit_subplots(old_fig)

old_axes = get_axes(old_fig);

old_axes = old_axes(arrayfun(@(x) ~isempty(get_plots(x)), old_axes));

new_fig = incr_fig_indx();
mxfigs(new_fig);

for i=1:length(old_axes)
  
  tmp_new_axes = sc_square_subplot(length(old_axes), i);
  [x, y, width, height] = get_position(tmp_new_axes);
  delete(tmp_new_axes);
  
  tmp_new_axes = copyobj(old_axes(i), new_fig);
  set_position(tmp_new_axes,x, y, width, height);
  
end

for i=1:length(old_fig)
  delete(old_fig);
end

end