function triggerparents = get_triggerparents(obj)

tmin = obj.sequence.tmin;
tmax = obj.sequence.tmax;

triggerparents = obj.sequence.gettriggerparents(tmin, tmax);
triggerparents = triggerparents.cell_list;
triggerparents = concat_list({sc_tool.EmptyClass()}, triggerparents);

if ~isempty(obj.signal1.amplitudes.list)
  
  amplitude_token = sc_tool.EmptyClass();
  amplitude_token.source = obj.signal1;
  triggerparents = add_to_list(triggerparents, amplitude_token);
  
end

end