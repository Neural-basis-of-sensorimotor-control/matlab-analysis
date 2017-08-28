function generate_final_intra_figures_01(reset_experiments, plot_only_final_figures)

set_current_settings_tag(get_intra_analysis_tag());

response_min = 4e-3;
response_max = 18e-3;
height_limit = 2;
min_nbr_epsp = 5;
only_epsps = true;

neurons = intra_select_neurons(get_intra_neurons(), get_intra_motifs());
 
if reset_experiments
  reset_all_experiments(neurons, response_min, response_max, only_epsps);
end

%Generate figure 4
make_mosaic(neurons, [], height_limit, min_nbr_epsp, @jet, plot_only_final_figures);
make_amplitude_maximal_dimensions(neurons, height_limit, min_nbr_epsp, plot_only_final_figures);
test_statistic_significance_mosaic(neurons, only_epsps, height_limit, min_nbr_epsp, plot_only_final_figures);

%Generate figure 5
single_stim_response_in_pattern(neurons, response_min, response_max, plot_only_final_figures);

%Generate figure 6
make_mds_response_separate_cells(neurons, height_limit, min_nbr_epsp);

figs = get_all_figures();

if plot_only_final_figures
  intra_from_debug_to_release_tick_label(figs);
end

set_current_settings_tag(get_default_settings_tag());

end