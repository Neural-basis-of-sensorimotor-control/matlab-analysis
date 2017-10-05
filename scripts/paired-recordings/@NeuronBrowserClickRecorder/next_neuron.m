function next_neuron(obj)

if obj.neuron_pair_indx == 1
  
  obj.neuron_pair_indx = 2;
  
else
  
  obj.neuron_pair_indx = 1;
  ind_neuron           = find(obj.neuron == obj.neurons);
  obj.neuron           = obj.neurons(ind_neuron + 1);
  
  
  debug_printout(mfilename, ind_neuron, length(obj.neurons));
  
end

plot_neuron(obj);

end