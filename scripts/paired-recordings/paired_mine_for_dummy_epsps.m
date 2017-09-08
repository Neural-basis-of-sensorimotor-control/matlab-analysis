function paired_mine_for_dummy_epsps(experiment_file)

if ischar(experiment_file) && size(experiment_file, 1) > 1
  
  experiment_cell = cell(size(experiment_file, 1), 1);
  
  for i=1:size(experiment_file, 1)
    
    experiment_cell(i) = {experiment_file(i, :)};
    
  end
  
  experiment_file = experiment_cell;
  
end



if iscell(experiment_file)
  
  fprintf('data = {\n')
  
  vectorize_fcn(@paired_mine_for_dummy_epsps, experiment_file)
  
  fprintf('}\n');
  return
  
end

experiment = ScExperiment.load_experiment(experiment_file);

for i_file=1:experiment.n
  
  file = experiment.get(i_file);
  
  for i_signal=1:file.signals.n
    
    signal = file.signals.get(i_signal);
    
    for i_waveform=1:signal.waveforms.n
      
      waveform = signal.waveforms.get(i_waveform);
      
      %       if startsWith(waveform.tag, 'dummy')
      %
      %         fprintf('''%s'' ''%s'' ''%s'' -inf inf {''%s''}\n', ...
      %           experiment.save_name, ...
      %           file.tag, ...
      %           signal.tag, ...
      %           waveform.tag);
      %
      %         signal.recalculate_waveform(waveform);
      %         signal.parent.sc_save(false);
      %
      %       end
      
      if startsWith(waveform.tag, 'remove-spike-') || ...
          startsWith(waveform.tag, 'e-psp-')
        
        fprintf('''%s'' ''%s'' ''%s'' -inf inf {''%s''}\n', ...
          experiment.save_name, ...
          file.tag, ...
          signal.tag, ...
          waveform.tag);
        
        signal.recalculate_waveform(waveform);
        
        if isempty(waveform.gettimes(0,inf))
          error('%s %s', file.tag, waveform.tag)
        end
        
        
        signal.parent.sc_save(false);
        
      end
      
    end
    
  end
  
end

end