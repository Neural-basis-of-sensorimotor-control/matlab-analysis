clear

response_min = 4e-3;
response_max = 18e-3;
only_epsps = true;

reset_all_experiments(response_min, response_max, only_epsps);

single_stim_response_in_pattern(response_min, response_max);

make_mosaic(11:18)

test_statistic_significance_mosaic(only_epsps);
