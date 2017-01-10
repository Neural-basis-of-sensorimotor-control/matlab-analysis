function sc_thicken_line(axhandle, plothandle)

if ~strcmp(axhandle(1).Type, 'axes')
  axhandle = get_axes(axhandle);
end

if ~ischar(plothandle(1)) && ~strcmp(plothandle(1).Type, 'line')
  plothandle = get_axes(plothandle);
end

all_plots = get_plots(axhandle);

for i=1:length(all_plots)
  
  if ischar(plothandle)
    if strcmp(all_plots(i).Tag, plothandle)
      all_plots(i).LineWidth = 2;
      uistack(all_plots(i));
      continue
    end 
  elseif plothandle == all_plots(i)
    all_plots(i).LineWidth = 2;
    uistack(all_plots(i));
    continue
  end
  
  all_plots(i).LineWidth = 1;
end
end
