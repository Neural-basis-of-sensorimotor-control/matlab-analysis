function axis_wide(ax, use_axes, xmargin, ymargin, set_tight)

if nargin<1
  ax = gca;
elseif isa(ax, 'matlab.ui.Figure')
  ax = get_axes(ax);
end

if nargin<2
  use_x = true;
  use_y = true;
else
  use_x = any(use_axes == 'x');
  use_y = any(use_axes == 'y');
end

if nargin<3
  xmargin = 1;
end

if nargin<4
  ymargin = 1;
end

if nargin<5
  set_tight = true;
end

xmin = inf;
xmax = -inf;

if use_x && ~set_tight
  for j=1:length(ax)
    x_limits = xlim(ax(j));
    xmin = min([xmin x_limits(1)]);
    xmax = max([xmax x_limits(2)]);
  end
end

ymin = inf;
ymax = -inf;
if use_y && ~set_tight
  for j=1:length(ax)
    y_limits = ylim(ax(j));
    ymin = min([ymin y_limits(1)]);
    ymax = max([ymax y_limits(2)]);
  end
end

for i=1:length(ax)
  
  children = get(ax(i), 'Children');
  
  for j=1:length(children)
    ch = children(j);
    
    if isa(ch, 'matlab.graphics.chart.primitive.Line')
      
      if use_x
        x =  get(ch, 'XData');
        xmin = min([xmin; (x(:)-xmargin)]);
        xmax = max([xmax; (x(:)+xmargin)]);
      end
      
      if use_y
        y =  get(ch, 'YData');
        ymin = min([ymin; (y(:)-ymargin)]);
        ymax = max([ymax; (y(:)+ymargin)]);
      end
      
    end
  end
end

for i=1:length(ax)
  
  if use_x && ~isinf(xmin) && ~isinf(xmax)
    xlim(ax(i), [xmin xmax]);
  end
  
  if use_y && ~isinf(ymin) && ~isinf(ymax)
    ylim(ax(i), [ymin ymax]);
  end
end

end