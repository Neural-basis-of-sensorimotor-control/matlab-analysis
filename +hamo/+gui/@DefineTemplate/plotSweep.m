function plotSweep(obj, sweep, time, tag)

if isempty(sweep)
  return
end

for i=1:size(sweep, 2)
  plot(obj.axes22, time, sweep(:, i), 'HitTest', 'off', 'Tag', tag);
end

end
