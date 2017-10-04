function update_clicked_points(obj, x_, y_)

update_clicked_points@ClickRecorder(obj, x_, y_);

xvalues = obj.neuron.x{obj.neuron_pair_indx};
yvalues = obj.neuron.y{obj.neuron_pair_indx};

xvalues(obj.active_index) = x_;
yvalues(obj.active_index) = y_;

obj.neuron.x(obj.neuron_pair_indx) = {xvalues};
obj.neuron.y(obj.neuron_pair_indx) = {yvalues};

end