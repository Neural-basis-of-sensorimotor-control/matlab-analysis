function next_neuron(obj)

obj.neuron.x(2) = {cell2mat({obj.clicked_points.x})};
obj.neuron.y(2) = {cell2mat({obj.clicked_points.y})};

ind_neuron = find(obj.neuron == obj.neurons);
obj.neuron = obj.neurons(ind_neuron + 1);
plot_neuron(obj);

end