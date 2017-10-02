clc
clear
close all
reset_fig_indx()
set_current_settings_tag(get_intra_analysis_tag());

intra_load_settings
intra_load_constants

set_debug_mode('exceptional')

intra_make_mds_response_separate_cells(neurons([4 8]), height_limit, min_nbr_epsp);
mxfigs
%brwfigs

set_current_settings_tag(get_default_settings_tag());

figs = get_all_figures();

mxfigs

for i=1:length(figs)
  sc_fit_subplots(figs(i))
end