function plotSweep(obj, sweep, time, tag)

if isempty(sweep)
  return
end

if ~isempty(obj.rectificationPoint)
  
  [~, indx] = min(abs(time - obj.rectificationPoint));
  
  for i=1:size(sweep, 2)
    sweep(:,i) = sweep(:, i) - sweep(indx, i);
  end
end

for i=1:size(sweep, 2)
  plot(obj.axes22, time, sweep(:, i), 'HitTest', 'off', 'Tag', tag);
end


end
