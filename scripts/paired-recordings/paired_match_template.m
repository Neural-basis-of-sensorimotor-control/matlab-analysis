function [is_match, latency_mean, latency_std, amplitude_mean, amplitude_std] ...
  = paired_match_template(signal, sweeps, sweep_times, t_range, templates)

dim          = [1 size(sweeps, 2)];
is_match     = false(dim);
latencies    = nan(dim);
amplitudes   = nan(dim);
[~, indx_t0] = min(abs(sweep_times));
b_response_window = sweep_times > t_range(1) & sweep_times < t_range(2);

for i=1:length(templates)
  
  template = signal.triggers.get('tag', templates{i});
  
  if ~isempty(template.imported_spikedata) || ~isempty(template.predefined_spiketimes) ...
      || ~isempty(template.imported_spiketimes)
    
    error('!!!');
    
  end
  
  for j=1:size(sweeps, 2)
    
    template_times = sweep_times(template.match_v(sweeps(:,j)));
    pos            = template_times > t_range(1) & template_times < t_range(2);
    
    if nnz(pos)
      
      is_match(j) = true;
      latencies(j) = min(latencies(j), min(template_times(pos)));
      amplitudes(j) = max(amplitudes(j), max(sweeps(b_response_window, j) - sweeps(indx_t0, j)));
    
    end
  end
  
end

latency_mean   = mean(latencies(is_match));
latency_std    = std(latencies(is_match));
amplitude_mean = mean(amplitudes(is_match));
amplitude_std  = std(amplitudes(is_match));

end