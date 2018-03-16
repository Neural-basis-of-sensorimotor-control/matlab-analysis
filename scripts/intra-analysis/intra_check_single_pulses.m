function p = intra_check_single_pulses(modality, neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

height_limit      = 2;
min_nbr_epsp      = 5;
nbr_of_electrodes = 4;

neurons = intra_get_neurons();

if ~nargin
  modality = 'height';
end

if nargin>=2
  neurons = neurons(neuron_indx);
end



load intra_data.mat

str_single = {'1p electrode 1#V1#1'
  '1p electrode 1#V1#2'
  '1p electrode 1#V1#3'
  '1p electrode 1#V1#4'
  '1p electrode 1#V1#5'
  '1p electrode 2#V2#1'
  '1p electrode 2#V2#2'
  '1p electrode 2#V2#3'
  '1p electrode 2#V2#4'
  '1p electrode 2#V2#5'
  '1p electrode 3#V3#1'
  '1p electrode 3#V3#2'
  '1p electrode 3#V3#3'
  '1p electrode 3#V3#4'
  '1p electrode 3#V3#5'
  '1p electrode 4#V4#1'
  '1p electrode 4#V4#2'
  '1p electrode 4#V4#3'
  '1p electrode 4#V4#4'
  '1p electrode 4#V4#5'};

[~, electrode_indx] = get_electrode(str_single);

p = [];

for i=1:nbr_of_electrodes
  
  indx1 = electrode_indx == i;  
  p = concat_list(p, intra_plot_intra_stim(neurons, str_single(indx1), height_limit, ...
    min_nbr_epsp, false, modality));
  
end

incr_fig_indx()

edges = 0:.05:1;
histogram(p, edges, 'Normalization', 'probability')
title(['P values for ' modality ' comparison between first, second, ... fifth single pulse (N = ' num2str(length(p)) ') for each cell and electrode'])
ylabel('Probability')
xlabel('P value')
set(gca, 'XTick', mean(diff(edges)) + edges)

end