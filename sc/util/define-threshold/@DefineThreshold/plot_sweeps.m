function plot_sweeps(obj)

cla(obj.h_axes);

hold(obj.h_axes, 'on');

if ~isempty(obj.v)
  
  t = (1:size(obj.v, 1)) * obj.dt;
  
  for i=1:size(obj.v, 2)
    
    h_plot = plot(t, obj.v(:,i));
    
    if ~isempty(obj.btn_dwn_fcn_plots)
      set(h_plot, 'ButtonDownFcn', @(src, ~) obj.btn_dwn_fcn_plots(src));
    else
      set(h_plot, 'ButtonDownFcn', []);
    end
    
  end
  
end

if ~isempty(obj.btn_dwn_fcn_axes)
  set(obj.h_axes, 'ButtonDownFcn', @(src, ~) obj.btn_dwn_fcn_axes(src));
else
  set(obj.h_axes, 'ButtonDownFcn', []);
end

end