clear

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

nbr_of_simulations = 1e6;

load intra_data.mat

str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

stim_exists = false(size(str_first_stims));

for i=1:length(str_first_stims)
  stim_exists(i) = any(cellfun(@(x) strcmp(str_first_stims{i}, x), str_stims));
end

str_first_stims = str_first_stims(stim_exists);

%if reset_experiments
% intra_reset_all_experiments(neurons, response_min, response_max, only_epsps, height_limit);
%end

% p_inter_neuron = intra_plot_inter_neuron(neurons, str_stims([27 48]), height_limit, min_nbr_epsp, plot_only_final_figures);
% p_inter_stim   = intra_plot_intra_stim(neurons([8 9 10]),   str_stims, height_limit, min_nbr_epsp, plot_only_final_figures);

%p_inter_neuron = intra_plot_inter_neuron(neurons, str_stims([26 50 52]), height_limit, min_nbr_epsp, plot_only_final_figures);
%p_inter_stim   = intra_plot_intra_stim  (neurons, str_stims, height_limit, min_nbr_epsp, plot_only_final_figures);
intra_plot_intra_stim  (neurons, str_first_stims, height_limit, min_nbr_epsp, plot_only_final_figures);


%max_nbr_of_inter_neuron_comparisions = length(neurons)  *(length(neurons)-1)  / 2 * length(str_stims);
max_nbr_of_inter_stim_comparisions   = length(str_stims)*(length(str_stims)-1)/ 2 * length(neurons);

return

%intra_make_mosaic(neurons, [], height_limit, min_nbr_epsp, 'jet', plot_only_final_figures);

% incr_fig_indx()
% [simulated_distributions, measured_distributions, ideal_distributions, stim_pulses] ...
%   = intra_multinomial_1(neurons, response_min, response_max, plot_only_final_figures, nbr_of_simulations);
% save multinomial_v1_2_1e6.mat
% intra_plot_multinomial(simulated_distributions, measured_distributions, ideal_distributions, stim_pulses, neurons);

 [measured_distance, shuffled_distance] = intra_multinomial_2(neurons, response_min, response_max, plot_only_final_figures, ...
   nbr_of_simulations, str_stims);
save multinomial_v2_2_1e6.mat
%figs = get_all_figures();

sc_settings.set_current_settings_tag(sc_settings.get_default_settings_tag());

