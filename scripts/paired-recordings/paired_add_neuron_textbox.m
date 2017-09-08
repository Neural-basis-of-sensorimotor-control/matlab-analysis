function paired_add_neuron_textbox(neuron)

current_fig = gcf;
mgr = ColumnLayoutManager(current_fig, 'fixed_width', 200, 'fixed_height', 50);

txt = uicontrol('style', 'text', 'String', sprintf(neuron.comment));
mgr.add(txt);

btn = uicontrol('style', 'pushbutton', ...
  'String', sprintf('Load %s', neuron.file_tag), ...
  'Callback', @(~,~) neuron.load_experiment());
mgr.add(btn);

edit = uicontrol('style', 'edit', ...
  'String', 0, ...
  'Callback', @(tile, ~) move_zero_point(tile, gca));
mgr.add(edit);

prev_btn = uicontrol('style', 'pushbutton', ...
  'String', 'Previous figure', ...
  'Callback', @(~,~) browse_figure(current_fig, -1));
mgr.add(prev_btn);

nxt_btn = uicontrol('style', 'pushbutton', ...
  'String', 'Next figure', ...
  'Callback', @(~,~) browse_figure(current_fig, 1));
mgr.add(nxt_btn);

end

function browse_figure(fig, increment)

set_browse_figure_nbr(get(fig, 'Number'));
incr_fig_indx(increment);

end



function move_zero_point(tile, ax)

zero_point = str2num(get(tile, 'String'));

plots = get_plots(ax);

for i=1:length(plots)
  
  xdata = get(plots(i), 'XData');
  ydata = get(plots(i), 'YData');
  
  [~, ind] = min(abs(xdata - zero_point));
  ydata = ydata - ydata(ind);
  set(plots(i), 'YData', ydata);
  
end

end