function time_sequence = extract_time_sequence_disjunction(time_sequence_1, ...
  time_sequence_2)

if isempty(time_sequence_1)
  time_sequence = [];
  return
end

time_sequence = nan(size(time_sequence_1) + size(time_sequence_2));
counter_1 = 1;
counter_2 = 1;
counter = 0;

tstart = time_sequence_1(1,1);

while counter_1 <= size(time_sequence_1,1)
  
  %Find first end of sequence after tstart
  while time_sequence_1(counter_1,2) <= tstart
    counter_1 = counter_1+1;
    
    if counter_1 > size(time_sequence_1,1)
      %Running out of sequences
      time_sequence = time_sequence(1:counter, :);
      return
    end
    
  end
  
  %Start with highest value found
  tstart = max(tstart, time_sequence_1(counter_1,1));
  %Stop where sequence ends
  tstop = time_sequence_1(counter_1,2);
  
  %Find first end of second sequence after tstart
  while counter_2 <= size(time_sequence_2,1) && time_sequence_2(counter_2,2) <= tstart
    counter_2 = counter_2+1;
  end
  
  if counter_2 <= size(time_sequence_2,1)
    
    if time_sequence_2(counter_2,1) <= tstart
      %Start of second sequence is before tstart, thus tstart must be moved
      %to end of second sequence
      tstart = time_sequence_2(counter_2,2);
      
      if counter_2+1 <= size(time_sequence_2,1)
        %If second sequence has more elements, tstop occurs where either
        %first sequence list has next end of sequence, or second sequence
        %list has first start of sequence
        tstop = min(tstop, time_sequence_2(counter_2+1,1));
      end
      
    else
      %Start of second sequence is after tstart, meaning that it
      %terminates new sequence
      tstop = min(tstop, time_sequence_2(counter_2,1));
    end
    
  end
  
  if tstart < tstop
    counter = counter + 1;
    time_sequence(counter,:) = [tstart tsop];
  end
end

time_sequence = time_sequence(1:counter, :);

end