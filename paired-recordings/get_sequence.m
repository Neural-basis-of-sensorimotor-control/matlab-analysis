function sequence = get_sequence(t, max_diff)

time_diff = diff(t);

last_spike_in_sequence = [find(time_diff>max_diff); length(t)];
first_spike_in_sequence = [1; last_spike_in_sequence(1:end-1)+1];
at_least_one_spike = last_spike_in_sequence - first_spike_in_sequence > 1;

first_spike_in_sequence = first_spike_in_sequence(at_least_one_spike);
last_spike_in_sequence = last_spike_in_sequence(at_least_one_spike);

sequence = t([first_spike_in_sequence last_spike_in_sequence]);

% Compensate for inaccurate dimensionality for case with single sequence
if ~isempty(sequence) && size(sequence,2) == 1
  sequence = sequence';
end

end