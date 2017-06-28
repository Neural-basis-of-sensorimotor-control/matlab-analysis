function filename = get_download_amplitude_filename(viewer)

if isempty(viewer.amplitude)
  filename = '';
else
  filename = sprintf('%s_%.3d.dat', ...
    viewer.download_amplitude_filebase, ...
    viewer.download_amplitude_fileindex);
end