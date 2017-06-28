function update_experiment(obj, only_waveforms)

for i=1:obj.n
  
  file = obj.get(i);
  file.update_file(only_waveforms);

end

