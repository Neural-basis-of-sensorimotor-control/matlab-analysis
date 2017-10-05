function plot_neuron(obj)

obj.clicked_points        = struct('x', [], 'y', []);
obj.clicked_points(obj.n) = struct('x', [], 'y', []);

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(obj.neuron);

if obj.neuron_pair_indx == 1

  tmp_t2 = t2;
  t2 = t1;
  t1 = tmp_t2;

end

h_figure = get(obj.h_axes, 'Parent');
cla(obj.h_axes);
hold on

h_figure.Name = obj.neuron.file_tag;

sc_kernelhist(obj.h_axes, t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
[~, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, 10*kernelwidth, binwidth);
set(h_plot, 'LineWidth', 2);

obj.neuron.add_load_signal_menu([obj.h_axes], ...
  obj.neuron.template_tag{obj.neuron_pair_indx});

grid on

x = obj.neuron.x{obj.neuron_pair_indx};
y = obj.neuron.y{obj.neuron_pair_indx};

for i=1:length(x)
  
  obj.clicked_points(i).x = x(i);
  obj.clicked_points(i).y = y(i);
  
end

init_plot(obj);

str_properties = obj.neuron.str_properties;

for i=1:length(str_properties)
  
  val = obj.neuron.(str_properties{i});
  
  indx = val{obj.neuron_pair_indx};
  
  x_ = obj.neuron.x{obj.neuron_pair_indx}(indx);
  y_ = obj.neuron.y{obj.neuron_pair_indx}(indx);
  
  plot(obj.h_axes, x_, y_, 'Tag', str_properties{i}, 'LineWidth', 2, ...
    'ButtonDownFcn', @(~, ~) btn_dwn_define_click(obj));
  
end

h_legend = add_legend(obj.h_axes);
set(h_legend, 'InterPreter', 'None');

title(obj.h_axes, [obj.neuron.file_tag ' ' num2str(obj.neuron_pair_indx) ' (2), N = ' num2str(length(t2))], ...
  'Interpreter', 'none');

end