function sc_center_x_axis(ax)

if length(ax) > 1
  for i=1:length(ax)
    sc_center_x_axis(ax(i));
  end
else
  plots = sc_get_plots(ax);
  xmin = inf; xmax = -inf;
  
  for i=1:length(plots)
    x = plots(i).XData;
    
    if ~isempty(x)
      xmin = min([x(:); xmin]);
      xmax = max([x(:); xmax]);
    end
    
  end
  
  if xmin<inf && xmax>-inf && xmin ~= xmax
    xlim(ax, [xmin-1 xmax+1]);
  end

end