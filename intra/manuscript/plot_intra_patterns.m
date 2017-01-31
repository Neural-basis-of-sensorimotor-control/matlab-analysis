function plot_intra_patterns(scaling_dim)

neurons = get_intra_neurons();

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons))
  
  at_least_one_plot = plot_several_patterns(i, neurons(i), scaling_dim);
  
  if ~at_least_one_plot
    close
    continue
  end
end