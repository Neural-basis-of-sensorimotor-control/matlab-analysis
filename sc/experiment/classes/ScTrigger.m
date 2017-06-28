classdef ScTrigger < handle
  methods
    
    function [time, sweep] = perievent(obj, trigger_time, pretrigger, posttrigger)
      
      spike_time = obj.gettimes(min(trigger_time) + pretrigger,...
        max(trigger_time) + posttrigger);
      
      [time, sweep] = sc_perievent_sweep(trigger_time, spike_time, pretrigger, posttrigger);
    end
    
  end
end