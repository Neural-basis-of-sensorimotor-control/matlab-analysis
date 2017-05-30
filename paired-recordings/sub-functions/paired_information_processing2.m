%clc
clear
load overlapping_spiketrains.mat

sc_clf_all('reset')
reset_fig_indx()

max_inactivity_time            = 10;
min_nbr_of_spikes_per_sequence = 1;
min_time_span_per_sequence     = 2;

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 5e-3;
binwidth    = 1e-4;

pattern = get_intra_patterns();
pattern = pattern(~startsWith(pattern, '1p '));

%double_recordings = get_overlapping_spiketrains();

f = [];
tag = {};
marker = '';
counter = 0;


for i=1:len(overlapping_spiketrains)
  fprintf('%d (%d)\n', i, len(overlapping_spiketrains));
  double_cell = overlapping_spiketrains(i);
  
  %   signal = sc_load_signal(double_cell);
  %
  %   waveform1 = signal.waveforms.get('tag', double_cell.template_tag{1});
  %   waveform2 = signal.waveforms.get('tag', double_cell.template_tag{2});
  %
  %   t1 = waveform1.gettimes(double_cell.tmin, double_cell.tmax);
  %   t2 = waveform2.gettimes(double_cell.tmin, double_cell.tmax);
  
  [t1, t2, tag1, tag2] = get_paired_neurons_spiketimes(double_cell);
  
  double_cell.time_sequences = find_time_sequences(t1, t2, ...
    max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
    min_time_span_per_sequence);
  
  
  diff_time = diff(double_cell.time_sequences, 1, 2);
  [~, indx] = max(diff_time);
  
  double_cell.time_sequences(indx, :);
  
  plot_raster_paired_recordings(double_cell, double_cell.time_sequences, '');
  
  tmin = double_cell.time_sequences(1, 1);
  tmax = double_cell.time_sequences(1, 2);
  
  t1 = t1(t1 >=tmin & t1 <= tmax);
  t2 = t2(t2 >=tmin & t2 <= tmax);
  
  incr_fig_indx();
  clf('reset');
  
  pattern = ScSpikeTrainCluster.get_touch_pattern_headers();
  indx = ~startsWith(pattern, '1p electrode');
  pattern = pattern(indx);
  
  
  for j=1:length(pattern)
    
    tmp_pattern = pattern{j};
    t_pattern =   ScSpikeTrainCluster.load_times(...
      double_cell.neuron1.raw_data_file, tmp_pattern);
    
    sc_square_subplot(length(pattern), j)
    
    [tmp_f1, t, h_plot] = sc_kernelhist(t_pattern, t1, pretrigger, posttrigger, ...
      kernelwidth, binwidth);
    set(h_plot, 'Tag', 'cell A');
    hold on
    
    [tmp_f2, ~, h_plot] = sc_kernelhist(t_pattern, t2, pretrigger, posttrigger, ...
      kernelwidth, binwidth);
    set(h_plot, 'Tag', 'cell B');
    
    if ~isempty(tmp_f1) && any(tmp_f1(t>0))
      counter = counter + 1;
      f(counter, :) = tmp_f1(t>0);
      tag(counter) = {[double_cell.neuron1.file_tag]};
      marker(counter) = '+';
    end
    
    if ~isempty(tmp_f2) &&  any(tmp_f2(t>0))
      counter = counter + 1;
      f(counter, :) = tmp_f2(t>0);
      tag(counter) = {[double_cell.neuron2.file_tag]};
      marker(counter) = '*';
    end
    
    title([double_cell.neuron1.file_tag ': ' tmp_pattern]);
  end
  
  add_legend(get_axes(gcf), true, true);
end

f = f - mean(f(:));

[~, score, ~, ~, explained] = pca(f);

incr_fig_indx();
clf('reset')
hold on

for i=1:size(score, 1)
  plot(score(i,1), score(i,2), marker(i), 'Tag', tag{i});
end

add_legend(gca, true, true);