function plot_amplitude(obj)

[v, time] = obj.plot_sweep(@(~,~) obj.btn_dwn_amplitude());

if size(v, 2) == 1
  
  [~, ind] = min(abs(time));
  
  text(0, double(v(ind)), 'start', 'HorizontalAlignment',...
    'center', 'Color', [0 1 0], ...
    'parent', obj.signal1_axes, 'HitTest', 'off');
  
  triggertime = obj.trigger_time(1);
  val         = obj.amplitude.get_data(triggertime, 1:4);
  
  if isfinite(val(1))
    
    plot(obj.signal1_axes, val(1), val(2), 'g+', 'MarkerSize', 6, ...
      'LineWidth', 2, 'HitTest', 'off');
    
  end
  
  if isfinite(val(3))
    
    plot(obj.signal1_axes, val(3), double(val(4)), 'b+', 'MarkerSize', 6, ...
      'LineWidth', 2, 'HitTest', 'off');
    
  end
  
  set(obj.signal1_axes, 'ButtonDownFcn', @(~,~) obj.btn_dwn_amplitude());
  
end

end

