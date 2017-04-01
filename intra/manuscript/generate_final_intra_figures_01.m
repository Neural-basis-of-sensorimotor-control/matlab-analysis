clc
clear
close all

response_min = 4e-3;
response_max = 18e-3;

reset_fig_indx();

reset_all_experiments(response_min, response_max);

single_stim_response_in_pattern(response_min, response_max);

make_mosaic(1:3)

test_statistic_significance_mosaic