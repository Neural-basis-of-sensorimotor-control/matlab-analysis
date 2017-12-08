nbrofsets        = size(shuffled_distance, 1);
nbrofneurons     = size(shuffled_distance, 2);
nbrofsimulations = size(shuffled_distance, 3);

incr_fig_indx()

clf

for i=1:nbrofsets
  
  shuffled_median = median(squeeze(shuffled_distance(i, :, :)), 2);
  shuffled_975 = prctile(squeeze(shuffled_distance(i, :, :)), 97.5, 2);
  shuffled_025 = prctile(squeeze(shuffled_distance(i, :, :)), 2.5, 2);
  
  sc_square_subplot(nbrofsets, i)
  cla
  hold on
  
  plot(measured_distance(i,:), 1:nbrofneurons, 'bs');
  plot(shuffled_median,        1:nbrofneurons, 'ro')
  plot(shuffled_975,           1:nbrofneurons, 'r-')
  plot(shuffled_025,           1:nbrofneurons, 'r-')

  title(intra_final_stim_tag([stim_pulses(i).pattern '#' stim_pulses(i).electrode]))
  
end