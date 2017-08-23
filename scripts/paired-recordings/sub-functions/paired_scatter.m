% Compare scatter plots!
% Compare latency to first response
clc
clear
sc_clf_all('reset');
reset_fig_indx();

max_inactivity_time            = 10;
min_nbr_of_spikes_per_sequence = 10;
min_time_span_per_sequence     = 2;

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 5e-3;
binwidth    = 1e-4;

pattern = get_intra_patterns();
%pattern = pattern(~startsWith(pattern, '1p '));

double_cell = ScNeuron('experiment_filename', 'BMNR_SSSA_sc.mat', ...
  'file_tag', 'BMNR0000', 'signal_tag', 'patch', 'template_tag', ...
  {'spike1-double', 'spike2-double'}, 'tag', 'BMNR_SSSA-double-1');

signal = sc_load_signal(double_cell);

waveform1 = signal.waveforms.get('tag', double_cell.template_tag{1});
waveform2 = signal.waveforms.get('tag', double_cell.template_tag{2});

t1 = waveform1.gettimes(double_cell.tmin, double_cell.tmax);
t2 = waveform2.gettimes(double_cell.tmin, double_cell.tmax);

double_cell.time_sequences = find_time_sequences(t1, t2, ...
  max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
  min_time_span_per_sequence);

plot_raster_paired_recordings(double_cell, double_cell.time_sequences, '');

tmin = double_cell.time_sequences(1, 1);
tmax = double_cell.time_sequences(1, 2);

t1 = t1(t1 >=tmin & t1 <= tmax);
t2 = t2(t2 >=tmin & t2 <= tmax);

counter = 0;
nbrofrows = 4;
nbrofcols = 4;

for i=1:length(pattern)
  
  tmp_pattern = pattern{i};
  t_pattern = signal.parent.gettriggers(0, inf).get('tag', tmp_pattern).gettimes(tmin, tmax);
  
  counter = mod(counter, nbrofrows*nbrofcols)+1;
  
  if counter > nbrofcols && mod(counter, nbrofcols) == 1
    counter = counter + nbrofcols;
  end
  
  if counter > nbrofcols * nbrofrows
    counter = 1;
  end
  
  if counter == 1
    incr_fig_indx();
  end
  
  subplot(nbrofrows, nbrofcols, counter)
  sc_raster(t_pattern, t1, pretrigger, posttrigger);
  title([tmp_pattern ' cell 1']);
  
  subplot(nbrofrows, nbrofcols, counter + nbrofcols)
  sc_raster(t_pattern, t2, pretrigger, posttrigger);
  title([tmp_pattern ' cell 2']);
  
end

latency_1 = cell(size(pattern));
latency_2 = cell(size(pattern));

for i=1:length(pattern)
  
  tmp_pattern = pattern{i};
  t_pattern = signal.parent.gettriggers(0, inf).get('tag', tmp_pattern).gettimes(tmin, tmax);
  
  tmp_latency = nan(size(t_pattern));
  
  for j=1:length(t_pattern)
    
    tmp_latency(j) = min(t1(t1>t_pattern(j))) - t_pattern(j);
  end
  
  latency_1(i) = {tmp_latency};
  
  tmp_latency = nan(size(t_pattern));
  
  for j=1:length(t_pattern)
    
    tmp_latency(j) = min(t2(t2>t_pattern(j))) - t_pattern(j);
  end
  
  latency_2(i) = {tmp_latency};
  
end
  
incr_fig_indx()
%subplot(1,2,1)
hold on
for i=1:length(latency_1)
  tmp_latency = latency_1{i};
  
  plot(tmp_latency, (3*i-1)*ones(size(tmp_latency)), 'k+', 'Tag', 'Cell I');
end

for i=1:length(latency_2)
  tmp_latency = latency_2{i};
  
  plot(tmp_latency, 3*i*ones(size(tmp_latency)), 'k+', 'Tag', 'Cell II');
end
yticklabel = sc_unpack_cell(cellfun(@(x) {'', x, x}, pattern, 'UniformOutput', false));

set(gca, 'YTick', 1:3*length(pattern), 'YTickLabel', yticklabel);
axis_wide(gca, 'y');
xlabel('Latency [s]')
title('Latencies')
h = add_legend(gca, true, true);
set(h, 'Color', 'w');
set(gca, 'Color', 'k');

mxfigs()


