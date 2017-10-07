function add_point(obj, indx, x_, y_)

obj.neuron.x{obj.neuron_pair_indx}(indx) = x_;
obj.neuron.y{obj.neuron_pair_indx}(indx) = y_;

add_point@ClickRecorder(obj, indx, x_, y_);

end