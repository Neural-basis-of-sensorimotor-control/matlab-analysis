function define_threshold(obj)

obj.btn_dwn_fcn_plots = @(src,~) obj.add_limits(src);
obj.btn_dwn_fcn_axes  = @(src,~) obj.add_limits(src);

obj.plot_sweeps();

if ~isempty(obj.x0)
  obj.plot_startpoint();
end

for i=1:obj.threshold.n
  obj.plot_limit(i);
end

obj.reset_active_objects();

set(obj.h_axes.Parent, 'WindowButtonMotionFcn', @(~,~) obj.move_object());
set(obj.h_axes.Parent, 'WindowButtonUpFcn',     @(~,~) obj.drop_object());

end