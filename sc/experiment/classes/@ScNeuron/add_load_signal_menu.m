function add_load_signal_menu(obj, graphics_object, trigger_tag)
% add_load_signal_menu(ScNeuron, graphics_object, trigger_tag)

for i=1:length(graphics_object)
  
  tmp_h = graphics_object(i);
  
  set(tmp_h, 'UIContextMenu', create_ui_context_menu(obj, trigger_tag));
  
end

end


function val = create_ui_context_menu(neuron, trigger_tag)

val = uicontextmenu();

uimenu(val, 'Label', 'Open in sc', 'Callback', ...
  @(~, ~) neuron.load_experiment(trigger_tag));

end