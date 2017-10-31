clear
sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());

intra_load_settings
intra_load_constants

if reset_experiments
 intra_reset_all_experiments(neurons, response_min, response_max, only_epsps, height_limit);
end

p_inter_neuron = intra_plot_inter_neuron(neurons, str_stims, height_limit, min_nbr_epsp, plot_only_final_figures);

p_inter_stim = intra_plot_intra_stim(neurons,   str_stims, height_limit, min_nbr_epsp, plot_only_final_figures);

max_nbr_of_inter_neuron_comparisions = length(neurons)*(length(neurons)-1)/2*length(str_stims);
max_nbr_of_inter_stim_comparisions = length(str_stims)*(length(str_stims)-1)/2*length(neurons);

intra_make_mosaic(neurons, [], height_limit, min_nbr_epsp, 'jet', plot_only_final_figures);

[simulated_distributions, measured_distributions, ideal_distributions, stim_pulses] = intra_single_stim_response_in_pattern(neurons, response_min, response_max, plot_only_final_figures);

intra_plot_multinomial(simulated_distributions, measured_distributions, ideal_distributions, stim_pulses, neurons);

figs = get_all_figures();

if plot_only_final_figures
  intra_from_debug_to_release_tick_label(figs);
end

sc_settings.set_current_settings_tag(sc_settings.get_default_settings_tag());

