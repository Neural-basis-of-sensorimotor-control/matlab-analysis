function [sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger)

signal = sc_load_signal(neuron);

v = signal.get_v(true, true, true, true);

trigger = signal.parent.gettriggers(-inf, inf).get('tag', neuron.template_tag{1});

try
  
  trigger_times = trigger.gettimes(0, inf);
  
catch
  
  error(neuron.file_tag)
  
end

trigger_times = trigger_times(trigger_times > neuron.tmin & trigger_times < neuron.tmax);

[sweeps, sweep_times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
  posttrigger, signal.dt);

end

