function generate_final_intra_figures_01(reset_experiments, plot_only_final_figures)

response_min = 4e-3;
response_max = 18e-3;
only_epsps = true;

if reset_experiments
  reset_all_experiments(response_min, response_max, only_epsps);
end

single_stim_response_in_pattern(response_min, response_max, plot_only_final_figures);

make_mosaic(true);%11:18)

test_statistic_significance_mosaic(only_epsps);

make_amplitude_maximal_dimensions();

make_mds_response_separate_cells();

end