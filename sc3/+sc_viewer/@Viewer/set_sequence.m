function set_sequence(obj, sequence)

obj.sequence = sequence;

if isempty(obj.sequence)
  
  signal1       = [];
  signal2       = [];
  trigger_parent = [];
  
else
  
  signal1 = get_set_val(obj.get_signals(), obj.signal1, 'patch');
  signal2 = get_set_val(obj.get_signals(), obj.signal2, ...
    ScSignal.empty_signal_tag);
  trigger_parent = get_set_val(obj.get_trigger_parents(), obj.trigger_parent, ...
    sc_experiment.TriggerParent.make_empty_class());
  
end

obj.set_signal1(signal1);
obj.set_signal2(signal2);
obj.set_trigger_parent(trigger_parent);

end