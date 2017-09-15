function plot_neuron(obj)

pretrigger = -1;
posttrigger = 1;
kernelwidth = 1e-3;
binwidth = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(obj.neuron);

h_figure = get(obj.h_axes, 'Parent');
cla(obj.h_axes);
h_figure.Name = obj.neuron.file_tag;

sc_kernelhist(obj.h_axes, t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);

grid on

x = obj.neuron.x{1};
y = obj.neuron.y{1};

for i=1:length(x)
  
  obj.clicked_points(i).x = x(i);
  obj.clicked_points(i).y = y(i);
  
end

init_plot(obj);

end