function remove_point(obj, index)

obj.neuron.x{obj.neuron_pair_indx}(index) = [];
obj.neuron.y{obj.neuron_pair_indx}(index) = [];

remove_point@ClickRecorder(obj, index);

end