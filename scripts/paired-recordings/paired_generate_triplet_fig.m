%Substitute example triplet with CFNR0003
clear
paired_setup

reset_fig_indx()

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 1e-3;
binwidth    = 1e-3;

file_tags = unique({ec_neurons.file_tag});

triplet_file_tags = file_tags(arrayfun(@(y) nnz(arrayfun(@(x) strcmp(x.file_tag, y), ec_neurons))>1, file_tags));

triplets_list = {};

i=1;

triplets = ec_neurons(arrayfun(@(x) strcmp(x.file_tag, triplet_file_tags{i}), ec_neurons));

triplets_list = add_to_list(triplets_list, triplets);

% incr_fig_indx()
% clf

for j=1:length(triplets)
  
  tmp_triplet_1 = triplets(j);
  [t1, t2] = paired_get_neuron_spiketime(tmp_triplet_1);
  
  %sc_square_subplot(2*length(triplets), 2*j-1);
  incr_fig_indx()
  clf
  hold on
  
  sc_kernelhist(t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);
  [~, ~, h_plot] = sc_kernelhist(t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
  set(h_plot, 'LineWidth', 2);
  [freq_hist, bintimes] = sc_perifreq(t1, t2, pretrigger, posttrigger, 10*binwidth);
  bar(bintimes, freq_hist)
  %grid on
  axis tight
  title([tmp_triplet_1.file_tag ': ' tmp_triplet_1.template_tag{1} ' - ' tmp_triplet_1.template_tag{2}])
  
  %sc_square_subplot(2*length(triplets), 2*j-1);
  incr_fig_indx()
  clf
  hold on
  sc_kernelhist(t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
  [~, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, 10*kernelwidth, binwidth);
  set(h_plot, 'LineWidth', 2);
  [freq_hist, bintimes] = sc_perifreq(t2, t1, pretrigger, posttrigger, 10*binwidth);
  bar(bintimes, freq_hist)
  %grid on
  axis tight
  title([tmp_triplet_1.file_tag ': ' tmp_triplet_1.template_tag{2} ' - ' tmp_triplet_1.template_tag{1}])
  
end

