function paired_sort_neuron_points(ec_neurons)

for i=1:length(ec_neurons)
  
  tmp_neuron = ec_neurons(i);
  
  for j=1:2
    
    x_         = tmp_neuron.x{j};
    [x_, ind]  = sort(x_);
    y_         = tmp_neuron.y{j}(ind);
    
    tmp_neuron.x(j) = {x_};
    tmp_neuron.y(j) = {y_};
    
  end
  
  print_neuron(tmp_neuron);
  fprintf('\n')
  
end

end

