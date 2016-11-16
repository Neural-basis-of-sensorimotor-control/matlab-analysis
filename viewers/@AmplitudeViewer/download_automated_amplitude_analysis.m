function download_automated_amplitude_analysis(viewer)

amplitude = viewer.amplitude;

if isempty(amplitude)
  fprintf('No amplitude selected, could not save\n');
  return
end

filename = viewer.get_download_amplitude_filename;
amplitude.download_automated_amplitude_analysis(filename);
viewer.update_download_amplitude_fileindex;

end