function set_amplitude(viewer, amplitude)

viewer.amplitude = amplitude;
viewer.update_download_amplitude_fileindex;

if ~isempty(viewer.amplitude) && numel(viewer.triggertimes)
  viewer.set_mouse_press(1);
  viewer.download_amplitude_filebase = amplitude.get_amplitude_filebase;
else
  viewer.download_amplitude_filebase = '';
end

viewer.amplitude_average_channel.update();

end