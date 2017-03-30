clear

displayopt = 'off';

neurons = get_intra_neurons();
stims = get_intra_motifs();

dim = size(neurons);
p_inter_stimulation = nan(dim);
p_shuffled_inter_stimulation = nan(dim);

properties = {'height', 'latency', 'width'};

for i=1:length(properties)
  fprintf('%d out of %d\n', i, length(properties));
  
  property = properties{i};
  
  for j=1:length(neurons)
    neuron = neurons(j);
    signal = sc_load_signal(neuron);
    activity_threshold = get_activity_threshold(signal);
    amplitudes = get_items(signal.amplitudes.list, 'tag', stims);
    
    tags = [];
    data = [];
    
    for k=1:length(amplitudes)
      amplitude = amplitudes(k);
      
      if amplitude.userdata.fraction_detected < activity_threshold
        continue
      end
      
      value = amplitude.(property);
      str = strsplit(amplitude.tag, '#');
      str = str{2};
      ind = str2num(str(2));
      
      switch property
        case 'height'
          norm_constant = amplitude.parent.userdata.single_pulse_height(ind);
        case 'latency'
          norm_constant = amplitude.parent.userdata.single_pulse_latency(ind);
        case 'width'
          norm_constant = amplitude.parent.userdata.single_pulse_width(ind);
        otherwise
          error('Illegal property: %s', property);
      end
      
      value = value / norm_constant;
      
      for m=1:length(value)
        tags = add_to_list(tags, amplitude.tag);
        data = add_to_list(data, value(m));
      end
    end
    
    [p_inter_stimulation(j), anovatab, stats] = anova1(data, tags, displayopt);
    
    ind_shuffled = randperm(length(data));
    data_shuffled = data(ind_shuffled);
    
    [p_shuffled_inter_stimulation(j), anovatab_shuffled, stats_shuffled] = ...
      anova1(data_shuffled, tags, displayopt);
  end
  
  incr_fig_indx()
  clf reset
  semilogy(1:length(p_inter_stimulation), p_inter_stimulation, 'Tag', 'Results');
  hold on
  semilogy(1:length(p_inter_stimulation), p_shuffled_inter_stimulation, 'Tag', 'Shuffled results');
  axis_wide(gca, 'xy');
  set(gca, 'XTick', 1:length(p_inter_stimulation), 'XTickLabel', ...
    {neurons.file_tag}, 'XTickLabelRotation', 270);
  xlabel('Neurons');
  ylabel('P value');
  title(['One-way ANOVA for ' property ' values']);
  add_legend();
  
  incr_fig_indx()
  
  subplot(211)
  [counts, edges] = histcounts(p_inter_stimulation, 'BinLimits', [0 1]);
  bar(.5*(edges(1:end-1) + edges(2:end)), counts/sum(counts));
  xlabel('P value');
  ylabel('Distribution');
  title(['p value distribution for ' property]);
  
  subplot(212)
  [counts, edges] = histcounts(p_shuffled_inter_stimulation, 'BinLimits', [0 1]);
  bar(.5*(edges(1:end-1) + edges(2:end)), counts/sum(counts));
  xlabel('P value');
  ylabel('Distribution');
  title(['Shuffled p value distribution for ' property]);
end


for i=1:length(properties)
  fprintf('%d out of %d\n', i, length(properties));
  
  property = properties{i};
  
  for j=1:length(stims)
    
    fprintf('\t%d out of %d\n', j, length(stims));
    stim = stims{j};
    tags = [];
    data = [];
    
    for k=1:length(neurons)
      neuron = neurons(k);
      signal = sc_load_signal(neuron);
      activity_threshold = get_activity_threshold(signal);
      amplitude = get_items(signal.amplitudes.list, 'tag', stim);
      
      if amplitude.userdata.fraction_detected < activity_threshold
        continue
      end
      
      value = amplitude.(property);
      str = strsplit(amplitude.tag, '#');
      str = str{2};
      ind = str2num(str(2));
      
      switch property
        case 'height'
          norm_constant = amplitude.parent.userdata.single_pulse_height(ind);
        case 'latency'
          norm_constant = amplitude.parent.userdata.single_pulse_latency(ind);
        case 'width'
          norm_constant = amplitude.parent.userdata.single_pulse_width(ind);
        otherwise
          error('Illegal property: %s', property);
      end
      
      value = value / norm_constant;
      
      for m=1:length(value)
        tags = add_to_list(tags, neuron.file_tag);
        data = add_to_list(data, value(m));
      end
    end
    
    [p_inter_stimulation(j), anovatab, stats] = anova1(data, tags, displayopt);
    
    ind_shuffled = randperm(length(data));
    data_shuffled = data(ind_shuffled);
    
    [p_shuffled_inter_stimulation(j), anovatab_shuffled, stats_shuffled] = ...
      anova1(data_shuffled, tags, displayopt);
  end
  
  incr_fig_indx()
  clf reset
  semilogy(1:length(p_inter_stimulation), p_inter_stimulation, 'Tag', 'Results');
  hold on
  semilogy(1:length(p_inter_stimulation), p_shuffled_inter_stimulation, 'Tag', 'Shuffled results');
  axis_wide(gca, 'xy');
  set(gca, 'XTick', 1:length(p_inter_stimulation), 'XTickLabel', ...
    stims, 'XTickLabelRotation', 270);
  xlabel('Stimulations');
  ylabel('P value');
  title(['One-way ANOVA for ' property ' values']);
  add_legend();
  
  incr_fig_indx();
  
  subplot(211)
  [counts, edges] = histcounts(p_inter_stimulation, 'BinLimits', [0 1]);
  bar(.5*(edges(1:end-1) + edges(2:end)), counts/sum(counts));
  xlabel('P value');
  ylabel('Distribution');
  title(['p value distribution for ' property]);
  
  subplot(212)
  [counts, edges] = histcounts(p_shuffled_inter_stimulation, 'BinLimits', [0 1]);
  bar(.5*(edges(1:end-1) + edges(2:end)), counts/sum(counts));
  xlabel('P value');
  ylabel('Distribution');
  title(['Shuffled p value distribution for ' property]);
end



