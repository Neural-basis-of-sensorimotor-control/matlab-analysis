function [sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger)

signal = sc_load_signal(neuron);

v = signal.get_v(true, true, true, true);

trigger = signal.parent.gettriggers(0, inf).get('tag', neuron.template_tag{1});
trigger_times = trigger.gettimes(0, inf);

for i=1:length(neuron.ic_fcn)
  
  fcn = neuron.ic_fcn{i};
  [v, trigger_times] = fcn(v, trigger_times, signal, neuron, pretrigger, posttrigger);
  
end

[sweeps, sweep_times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
  posttrigger, signal.dt);

end

