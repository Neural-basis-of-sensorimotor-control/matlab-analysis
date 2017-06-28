clc
sc_clf_all('reset')
clear
reset_fig_indx()

max_inactivity_time            = 10;
min_nbr_of_spikes_per_sequence = 10;
min_time_span_per_sequence     = 2;

t_start_presynaptic  = .2;
t_stop_presynaptic   = .4;
t_start_postsynaptic = .4;
t_stop_postsynaptic  = .8;
t_start_control      = .01;
t_stop_control       = .2;

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

t_presynaptic = waveform1.gettimes(double_cell.tmin, double_cell.tmax);
t_postsynaptic = waveform2.gettimes(double_cell.tmin, double_cell.tmax);

double_cell.time_sequences = find_time_sequences(t_presynaptic, t_postsynaptic, ...
  max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
  min_time_span_per_sequence);

plot_raster_paired_recordings(double_cell, double_cell.time_sequences, '');

tmin = double_cell.time_sequences(1, 1);
tmax = double_cell.time_sequences(1, 2);

t_presynaptic = t_presynaptic(t_presynaptic >=tmin & t_presynaptic <= tmax);
t_postsynaptic = t_postsynaptic(t_postsynaptic >=tmin & t_postsynaptic <= tmax);


for i=1:length(pattern)
  
  tmp_pattern = pattern{i};
  t_pattern = signal.parent.gettriggers(0, inf).get('tag', tmp_pattern).gettimes(tmin, tmax);
  
  incr_fig_indx();
  sc_kernelhist(t_pattern, t_presynaptic, pretrigger, posttrigger, ...
    kernelwidth, binwidth);
  
  presynaptic_firing = arrayfun(@(x) any((t_presynaptic >= (x+t_start_presynaptic)) & ...
    (t_presynaptic <= (x+t_stop_presynaptic))), t_pattern);
  
  incr_fig_indx();
  subplot(1,2,1)
  [f_pre_postsynaptic_firing, t] = sc_kernelhist(t_pattern(presynaptic_firing), ...
    t_postsynaptic, pretrigger, posttrigger, kernelwidth, binwidth);
  title(num2str(nnz(presynaptic_firing)));
  
  subplot(1,2,2)
  f_postsynaptic_firing = sc_kernelhist(t_pattern(~presynaptic_firing), ...
    t_postsynaptic, pretrigger, posttrigger, kernelwidth, binwidth);
  title(num2str(nnz(~presynaptic_firing)));
  
  linkaxes(get_axes(gcf));
  
  indx = t>=t_start_postsynaptic & t <= t_stop_postsynaptic;
  
  fprintf('%f\n', sum(f_pre_postsynaptic_firing(indx))/(sum(f_pre_postsynaptic_firing(indx)) + sum(f_postsynaptic_firing(indx)))-.5);
  
end
