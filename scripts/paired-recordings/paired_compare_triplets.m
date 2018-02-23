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

for i=1:length(triplet_file_tags)
  
  triplets = ec_neurons(arrayfun(@(x) strcmp(x.file_tag, triplet_file_tags{i}), ec_neurons));
    
  triplets_list = add_to_list(triplets_list, triplets);
  
  incr_fig_indx()
  clf
  
  for j=1:length(triplets)  
    
    tmp_triplet_1 = triplets(j);
    [t1, t2] = paired_get_neuron_spiketime(tmp_triplet_1);
    
    sc_square_subplot(2*length(triplets), 2*j-1);
    hold on
    sc_kernelhist(t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);
    [~, ~, h_plot] = sc_kernelhist(t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
    set(h_plot, 'LineWidth', 2);
    grid on
    title([tmp_triplet_1.file_tag ': ' tmp_triplet_1.template_tag{1} ' - ' tmp_triplet_1.template_tag{2}])
    
    sc_square_subplot(2*length(triplets), 2*j);
    hold on
    sc_kernelhist(t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
    [~, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, 10*kernelwidth, binwidth);
    set(h_plot, 'LineWidth', 2);
    grid on
    
  end
  
end

ind1 = 0;

labels = {};

clear dist

avg_dist_same = [];
avg_dist_different = [];

for i=1:length(triplets_list)
  
  sc_debug.print(i, length(triplets_list));
  
  tmp_triplet_list_1 = triplets_list{i};
  
  for j=1:length(tmp_triplet_list_1)
    
    tmp_triplet_1 = tmp_triplet_list_1(j);
    ind1 = ind1 + 1;
    ind2 = 0;
    labels = add_to_list(labels, tmp_triplet_1.file_tag);
    
    for k=1:length(triplets_list)
  
      tmp_triplet_list_2 = triplets_list{k};
      
      for m=1:length(tmp_triplet_list_2)
        
        tmp_triplet_2 = tmp_triplet_list_2(m);
        ind2 = ind2+1;
        
        d = paired_compare_pairs(tmp_triplet_1, tmp_triplet_2);
        dist(ind1, ind2) = d;
        
        if length(tmp_triplet_list_1) == length(tmp_triplet_list_2) && ...
          all(tmp_triplet_list_1 == tmp_triplet_list_2)
        
          if ind1 ~= ind2
            avg_dist_same = add_to_list(avg_dist_same, d);
          end
        else
          avg_dist_different = add_to_list(avg_dist_different, d);
        end
        
      end
      
    end
    
  end
  
end
%     
incr_fig_indx();
clf

subplot(1,2,1)
fill_matrix(dist);
hold on
colorbar
set(gca, 'XTick', (1:length(labels)), 'XTickLabel', labels, ...
  'YTick', (1:length(labels)), 'YTickLabel', labels, ...
  'XTickLabelRotation', 270);

for i=1:length(labels)
  for j=i:length(labels)
    fill(i + [-.5 -.5 .5 .5 -.5], j + [-.5 .5 .5 -.5 -.5], 'w');
  end
end

axis tight

for i=2:length(labels)
  
  if ~strcmp(labels{i-1}, labels{i})
    
    line(xlim, [i i]-.5, 'LineWidth', 4, 'Color', 'k');
    line([i i]-.5, ylim, 'LineWidth', 4, 'Color', 'k');
  
  end
end  
title('Dissimilarity value for neuron pairs')
colormap autumn

subplot(1,2,2)
h1=plot(avg_dist_same, ones(size(avg_dist_same)), '+');
hold on
h2=plot(avg_dist_different, 2*ones(size(avg_dist_different)), '+');
ylim([0 3])
set(gca, 'YTick', 1:2, 'YTickLabel', {'adjacent', 'non-adjacent'});
xl = xlim;
xlim([0 xl(2)]);
plot(mean(avg_dist_different), 2, 'o', 'Color', get(h2, 'Color'), 'LineWidth', 2)
plot(median(avg_dist_different), 2, '^', 'Color', get(h2, 'Color'), 'LineWidth', 2)
plot(mean(avg_dist_same), 1, 'o', 'Color', get(h1, 'Color'), 'LineWidth', 2)
plot(median(avg_dist_same), 1, '^', 'Color', get(h1, 'Color'), 'LineWidth', 2)
grid on

legend('Dissimilarity for adjacent neuron pairs', 'Dissimilarity for non-adjacent neuron pairs', 'mean', 'median');

