function download_amplitude_data(amplitude, savename)

pos = all(isfinite(amplitude.data), 2);
triggertimes = amplitude.stimtimes(pos)*1e3;
latency = amplitude.data(pos,1)*1e3;
voltage = amplitude.data(pos,4) - amplitude.data(pos,2);
time_to_peak = 1e3*(amplitude.data(pos,3) - amplitude.data(pos,1));

if exist(savename, 'file')
  
  answ = questdlg('Filename already exists. Overwrite?');
  
  if ~isempty(answ) && strcmp(answ,'Yes')
    save_file
  else
    return
  end
  
else
  save_file
end

fprintf('Plot %s saved\n', savename);

  function save_file()
    fid = fopen(savename, 'w');
    fprintf(fid, '%g,%g,%g,%g\n', [triggertimes latency voltage time_to_peak]');
    fclose(fid);
  end

end