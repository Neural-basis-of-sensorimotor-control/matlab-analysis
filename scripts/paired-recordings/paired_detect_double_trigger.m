function [v_single, v_first, v_second, v_middle] = paired_detect_double_trigger(signal, sweeps, sweep_times, trigger_tag, max_isi)

dim              = [1 size(sweeps, 2)];
is_single        = false(dim);
is_first_double  = false(dim);
is_second_double = false(dim);
is_middle        = false(dim); 
trigger          = signal.parent.gettriggers().get('tag', trigger_tag);

if ~strcmp(trigger.parent.tag, signal.tag)
  sweeps_trigger = sc_get_sweeps(trigger.parent.get_v(true, true, true, true), ...
    0, trigger.gettimes(0, inf), min(sweep_times), ...
    max(sweep_times), signal.dt);
else
  sweeps_trigger = sweeps;
end

for i=1:size(sweeps, 2)
  
  template_times = sweep_times(trigger.match_v(sweeps_trigger(:, i)) + 1);
  
  if ~any(template_times >= -eps & template_times <= eps)
    error('Incorrect trigger');
  end
  
  trigger_before = any(template_times >= -max_isi & template_times < -eps);
  trigger_after  = any(template_times > eps       & template_times <= max_isi);
  
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

v_single = sweeps(:, is_single);
v_first  = sweeps(:, is_first_double);
v_second = sweeps(:, is_second_double);
v_middle = sweeps(:, is_middle);

end