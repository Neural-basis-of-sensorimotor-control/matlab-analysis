function set_plot_color(handle, color)

if isa(handle, 'matlab.graphics.chart.primitive.Line')
  set(handle, 'Color', color);
elseif isa(handle, 'matlab.graphics.chart.primitive.Bar')
  set(handle, 'EdgeColor', color, 'FaceColor', color);
end

end