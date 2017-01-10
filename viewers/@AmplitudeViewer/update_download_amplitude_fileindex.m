function update_download_amplitude_fileindex(viewer)

viewer.download_amplitude_fileindex = 1;

while true  
  filename = viewer.get_download_amplitude_filename();
  
  if exist(filename, 'file')
    viewer.download_amplitude_fileindex = viewer.download_amplitude_fileindex + 1;
  else
    break;
  end
end