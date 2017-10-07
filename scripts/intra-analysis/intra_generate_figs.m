clear
close all
reset_fig_indx()
sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());

intra_load_settings
intra_load_constants
 
if reset_experiments
 intra_reset_all_experiments(neurons, response_min, response_max, only_epsps);
end

%Generate figure 4
intra_make_mosaic(neurons, [], height_limit, min_nbr_epsp, @jet, plot_only_final_figures);
intra_make_amplitude_maximal_dimensions(neurons, height_limit, min_nbr_epsp, plot_only_final_figures);
intra_test_statistic_significance_mosaic(neurons, only_epsps, height_limit, min_nbr_epsp, plot_only_final_figures);
return
%Generate figure 5
intra_single_stim_response_in_pattern(neurons, response_min, response_max, plot_only_final_figures);

%Generate figure 6
intra_make_mds_response_separate_cells(neurons, height_limit, min_nbr_epsp);

figs = get_all_figures();

if plot_only_final_figures
  intra_from_debug_to_release_tick_label(figs);
end

sc_settings.set_current_settings_tag(sc_settings.get_default_settings_tag());
