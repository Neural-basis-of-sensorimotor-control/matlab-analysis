function [sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger)

signal = sc_load_signal(neuron);

v = signal.get_v(true, true, true, true);

trigger = signal.parent.gettriggers(-inf, inf).get('tag', neuron.template_tag{1});

if isempty(trigger)
  
  fprintf('Warning: no trigger!\n')
  
end

trigger_times = trigger.gettimes(0, inf);

trigger_times = trigger_times(trigger_times > neuron.tmin & trigger_times < neuron.tmax);

[sweeps, sweep_times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
  posttrigger, signal.dt);

if ~strcmp(trigger.parent.tag, neuron.signal_tag)

  sweeps_trigger = sc_get_sweeps(trigger.parent.get_v(true, true, true, true), 0, trigger_times, pretrigger, ...
    posttrigger, signal.dt);
  
else
  
  sweeps_trigger = sweeps;
  
end
  
for i=1:size(sweeps, 2)
  
  template_times = sweep_times(trigger.match_v(sweeps_trigger(:, i)) + 1);
  
  if ~any(template_times >= -eps & template_times <= eps)
    error('Incorrect trigger');
  end
  
end

end

