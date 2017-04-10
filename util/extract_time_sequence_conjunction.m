function time_sequence = extract_time_sequence_conjunction(time_sequence_1, time_sequence_2)

if isempty(time_sequence_1) || isempty(time_sequence_2)
  time_sequence = [];
  return
end

time_sequence = nan(size(time_sequence_1,1) + size(time_sequence_2,1), 2);
counter_1 = 1;
counter_2 = 1;
counter = 0;

tstart = max(time_sequence_1(1,1), time_sequence_2(1,1));

while counter_1 <= size(time_sequence_1,1) && counter_2 <= size(time_sequence_2,1)
  fprintf('%d (%d) %d (%d)\n', counter_1, size(time_sequence_1,1), ...
    counter_2, size(time_sequence_2,1));
  
  %Move to end of first sequence after tstart
  while time_sequence_1(counter_1,2)<=tstart
    counter_1 = counter_1 + 1;
    
    if counter_1>size(time_sequence_1,1)
      time_sequence = time_sequence(1:counter, :);
      return
    end
  end
  
  %Move to end of second sequence after tstart
  while time_sequence_2(counter_2,2)<=tstart
    counter_2 = counter_2 + 1;
    
    if counter_2>size(time_sequence_2,1)
      time_sequence = time_sequence(1:counter, :);
      return
    end
  end
  
  tstart = max(time_sequence_1(counter_1,1), time_sequence_2(counter_2,1));
  tstop = min(time_sequence_1(counter_1,2), time_sequence_2(counter_2,2));
  
  if tstop > tstart
    counter = counter + 1;
    time_sequence(counter,:) = [tstart tstop];
  end
  
  tstart = tstop;
  
end

time_sequence = time_sequence(1:counter, :);

end