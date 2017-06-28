function time_sequence = merge_time_sequence(time_sequence)

[~, indx] = sort(time_sequence(:,1));

if any(diff(indx) ~= 1)
  warning('Untested function. Might result in rambles');
end

time_sequence = time_sequence(indx, :);

vertical_diff = diff(time_sequence(:,1), 1, 1);
horizontal_diff = diff(time_sequence(1:end-1,:), 1, 2);

indx = find(horizontal_diff > vertical_diff);

if ~isempty(indx)
  warning('Yet untested code. Might result in house setting on fire');
end

for i=1:length(indx)
  
  tstop = max(time_sequence(indx(i) + [0 1], 2));
  time_sequence(indx(i)+1,:) = [];
  time_sequence(indx(i), 2) = tstop;
  
end

end