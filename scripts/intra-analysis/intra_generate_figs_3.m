clc
clear
reset_fig_indx()

sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT);
sc_settings.get_default_experiment_dir
sc_debug.set_mode(false);

plot_only_final_figures = true;
only_epsps              = true;
height_limit = 2;
min_nbr_epsp = 5;

neurons = intra_get_neurons();
str_stims = get_intra_motifs();

intra_make_mosaic(neurons, [], height_limit, min_nbr_epsp, 'jet', plot_only_final_figures)

indx_stims = [26 52];

intra_plot_inter_neuron  (neurons, str_stims(indx_stims), height_limit, min_nbr_epsp, true, 'height');

P = .05;

all_p_values = intra_plot_inter_neuron  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'height', false);

fprintf('Height (neuron comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);

all_p_values = intra_plot_inter_neuron  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'width', false);

fprintf('Time to peak (neuron comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);

all_p_values = intra_plot_inter_neuron  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'latency', false);

fprintf('Latency (neuron comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);

all_p_values = intra_plot_intra_stim  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'height', false);

fprintf('Height (stim comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);

all_p_values = intra_plot_intra_stim  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'width', false);

fprintf('Time to peak (stim comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);

all_p_values = intra_plot_intra_stim  (neurons, str_stims, height_limit, ...
  min_nbr_epsp, true, 'latency', false);

fprintf('Latency (stim comparison): %d out of %d (%d %%) had P < %f\n', nnz(all_p_values < P), ...
  length(all_p_values), round(100 * nnz(all_p_values < P)/length(all_p_values)), ...
  P);
