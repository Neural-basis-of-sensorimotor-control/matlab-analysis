function show_plot_window(obj)

if isempty(obj.plot_window) || ~ishandle(obj.plot_window)
  obj.plot_window = figure;
end

set(obj.plot_window, 'ToolBar', 'None', 'MenuBar', 'none');

obj.triggeraxes  = sc_viewer.TriggerAxes(obj);
obj.channelaxes1 = sc_viewer.MainChannelAxes(obj);
obj.channelaxes2 = sc_viewer.ChannelAxes(obj);

end
