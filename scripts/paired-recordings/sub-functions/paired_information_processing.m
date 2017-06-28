%clc
clear
sc_clf_all('reset')
reset_fig_indx()

max_inactivity_time            = 10;
min_nbr_of_spikes_per_sequence = 1;%10;
min_time_span_per_sequence     = 2;

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 5e-3;
binwidth    = 1e-4;

pattern = get_intra_patterns();
pattern = pattern(~startsWith(pattern, '1p '));

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

incr_fig_indx();
clf('reset');

f1 = [];
f2 = [];

for i=1:length(pattern)
  
  tmp_pattern = pattern{i};
  t_pattern = signal.parent.gettriggers(0, inf).get('tag', tmp_pattern).gettimes(tmin, tmax);
  
  sc_square_subplot(length(pattern), i)
  
  [f1(:,i), t, h_plot] = sc_kernelhist(t_pattern, t1, pretrigger, posttrigger, ...
    kernelwidth, binwidth);
  set(h_plot, 'Tag', 'cell A');
  hold on
  
  [f2(:,i), ~, h_plot] = sc_kernelhist(t_pattern, t2, pretrigger, posttrigger, ...
    kernelwidth, binwidth);
  set(h_plot, 'Tag', 'cell B');
  
  title(tmp_pattern);
end
add_legend(get_axes(gcf), true, true);

f = [f1 f2];
f = f - mean(f(:));

[~, score, ~, ~, explained] = pca(f');

incr_fig_indx();
clf('reset')
hold on

for i=1:length(pattern)
  plot(score(i,1), score(i,2), '+', 'Tag', 'Cell A');
end


for i=(length(pattern)+1):2*length(pattern)
  plot(score(i,1), score(i,2), 'x', 'Tag', 'Cell B');
end

add_legend(gca, true, true);