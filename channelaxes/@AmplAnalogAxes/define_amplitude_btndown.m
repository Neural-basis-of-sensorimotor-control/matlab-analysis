function define_amplitude_btndown(obj)

if obj.gui.mouse_press>0
  p = get(obj.gui.main_axes,'currentpoint');
  t0 = p(1,1); v0 = p(1,2);
	
  if t0<0
    obj.gui.set_sweep(obj.gui.sweep + 1);
  else
    stimtime = obj.gui.triggertimes(obj.gui.sweep(1));
    obj.gui.amplitude.add_data(stimtime,2*obj.gui.mouse_press-[1 0],[t0 v0]);
    obj.gui.has_unsaved_changes = true;
		
    if obj.gui.mouse_press == 1
      obj.gui.set_mouse_press(2);
    else
      obj.gui.set_sweep(obj.gui.sweep + 1);
    end
  end
end

end