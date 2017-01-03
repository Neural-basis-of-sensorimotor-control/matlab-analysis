clc
clear
stims = get_intra_motifs();
neurons = get_intra_neurons();

electrodes = cellfun(@get_electrode, stims, 'UniformOutput', false);
patterns = cellfun(@get_pattern, stims, 'UniformOutput', false);

unique_electrodes = unique(electrodes);
unique_patterns = unique(patterns);

fprintf('---\n')
for i=1:length(unique_electrodes)
  fprintf('%s\t%d\n', unique_electrodes{i}, ...
    nnz(cellfun(@(x) strcmp(unique_electrodes{i}, x), electrodes)));
end

fprintf('---\n')
for i=1:length(unique_patterns)
  fprintf('%s\t%d\n', unique_patterns{i}, ...
    nnz(cellfun(@(x) strcmp(unique_patterns{i}, x), patterns)));
end

fprintf('---\n')
for i=1:length(unique_patterns)
  fprintf('%s\t%d\n', unique_patterns{i}, ...
    nnz(cellfun(@(x) strcmp(unique_patterns{i}, x), patterns) & ...
    cellfun(@(x) strcmp('V3', x), electrodes)));
end

ind = cellfun(@(x) strcmp('V3', x), electrodes);
stims = stims(ind);
patterns = patterns(ind);

load intra_data.mat

clf reset

for i=1:length(unique_patterns)
  %sc_square_subplot(length(unique_patterns), i);
  figure(i)
  hold on
  title([unique_patterns{i} ' amplitude height (mV)'])
  
  fprintf('%d\t(%d)\n', i, length(unique_patterns));
  
  stimparams = get_items(intra_patterns.stim_electrodes, ...
    'name', unique_patterns{i});
  stimparams = get_items(stimparams, 'type', 'V3');
  stimparams = get_items(stimparams, 'tag', stims);

  for j=1:length(neurons)
    neuron = neurons(j);
    signal = sc_load_signal(neuron);
    activity_threshold = get_activity_threshold(signal);

    amplitudes = get_items(signal.amplitudes.list, 'tag', {stimparams.tag});
    
    x = cell2mat({stimparams.time});
    y = nan(size(x));
    
    for k=1:length(stimparams)
      if amplitudes(k).userdata.fraction_detected >= activity_threshold
        y(k) = mean(amplitudes(k).height);
      end
    end
    
    x(isnan(y)) = [];
    y(isnan(y)) = [];
    
    if length(x) > 1
      plot(x,y,'Marker','+','LineStyle','-','Tag',neuron.file_str)
    end
  end
end

add_legend(get_all_figures)


