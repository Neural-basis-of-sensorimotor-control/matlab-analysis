clc
clear
close all
reset_fig_indx()
sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());

intra_load_settings
intra_load_constants

sc_debug.set_mode(true)

%intra_make_mds_response_separate_cells(neurons([4 8]), height_limit, min_nbr_epsp);
%mxfigs

intra_test_statistic_significance_mosaic(neurons, only_epsps, height_limit, min_nbr_epsp, plot_only_final_figures);

sc_settings.set_current_settings_tag(sc_settings.get_default_settings_tag());

% figs = get_all_figures();
% 
% mxfigs
% 
% for i=1:length(figs)
%   sc_fit_subplots(figs(i))
% end