function plot_neuron(obj)

obj.clicked_points        = struct('x', [], 'y', []);
obj.clicked_points(obj.n) = struct('x', [], 'y', []);

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(obj.neuron);

h_figure = get(obj.h_axes, 'Parent');
cla(obj.h_axes);
hold on

h_figure.Name = obj.neuron.file_tag;

sc_kernelhist(obj.h_axes, t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
[~, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, 10*kernelwidth, binwidth);
set(h_plot, 'LineWidth', 2);

grid on

x = obj.neuron.x{2};
y = obj.neuron.y{2};

for i=1:length(x)
  
  obj.clicked_points(i).x = x(i);
  obj.clicked_points(i).y = y(i);
  
end

init_plot(obj);

end