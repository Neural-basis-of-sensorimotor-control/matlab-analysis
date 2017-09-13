function download_amplitude_data(amplitude, savename)

pos = all(isfinite(amplitude.data), 2);
latency = amplitude.data(pos,1)*1e3;
voltage = amplitude.data(pos,4) - amplitude.data(pos,2);
time_to_peak = 1e3*(amplitude.data(pos,3) - amplitude.data(pos,1));

if exist(savename, 'file')
  
  answ = questdlg('Filename already exists. Overwrite?');
  
  if ~isempty(answ) && strcmp(answ,'Yes')
    
    fid = fopen(savename, 'w');
    fprintf(fid, '%g,%g,%g\n', [latency voltage time_to_peak]');
    fclose(fid);
    
  else
    
    return
  end
  
else
  
  fid = fopen(savename, 'w');
  fprintf(fid, '%g,%g,%g\n', [latency voltage time_to_peak]');
  fclose(fid);
  
end

fprintf('Plot %s saved\n', savename);

end