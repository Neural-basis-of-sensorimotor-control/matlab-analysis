function [times_single, times_first, times_second, times_middle] = ...
  paired_ec_double_spikes(times, max_isi)

dim              = size(times);
is_single        = false(dim);
is_first_double  = false(dim);
is_second_double = false(dim);
is_middle        = false(dim);

for i=1:length(times)
  
  tmp_time       = times(i);
  tmp_times      = times - tmp_time;
  tmp_times(i)   = [];
  
  trigger_before = any(tmp_times >= -max_isi & tmp_times < -eps);
  trigger_after  = any(tmp_times > eps       & tmp_times <= max_isi);
  
  if ~trigger_before && ~trigger_after
    is_single(i)        = true;
  elseif ~trigger_before && trigger_after
    is_first_double(i)  = true;
  elseif trigger_before && ~trigger_after
    is_second_double(i) = true;
  elseif trigger_before && trigger_after
    is_middle(i)       = true;
  else
    error('Inconsequent logic');
  end
  
end

times_single = times(is_single);
times_first  = times(is_first_double);
times_second = times(is_second_double);
times_middle = times(is_middle);

end