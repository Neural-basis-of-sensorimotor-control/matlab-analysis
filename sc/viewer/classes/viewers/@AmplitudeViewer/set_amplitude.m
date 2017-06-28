function set_amplitude(obj, amplitude)

amplitude = get_item(obj.main_signal.amplitudes.list, amplitude);

obj.amplitude = amplitude;
obj.update_download_amplitude_fileindex;

if ~isempty(obj.amplitude) && numel(obj.triggertimes)
  obj.set_mouse_press(1);
  obj.download_amplitude_filebase = amplitude.get_amplitude_filebase;
else
  obj.download_amplitude_filebase = '';
end

obj.amplitude_average_channel.update();

end