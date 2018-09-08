function plot_neuron(obj)

obj.clicked_points        = struct('x', [], 'y', []);
obj.clicked_points(obj.n) = struct('x', [], 'y', []);

pretrigger  = -2;
posttrigger = 2;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(obj.neuron);

if obj.neuron_pair_indx == 2
  
  tmp_t2 = t2;
  t2 = t1;
  t1 = tmp_t2;
  
end

h_figure = get(obj.h_axes, 'Parent');
cla(obj.h_axes);
hold on

h_figure.Name = obj.neuron.file_tag;

%[freq_hist, bintimes] = sc_perifreq(t1, t2, pretrigger, posttrigger, 10*binwidth);

%bar(bintimes, freq_hist);

%sc_kernelhist(obj.h_axes, t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);
[freq, t, h_plot] = sc_kernelhist(t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
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
  
  %plot(obj.h_axes, x_, y_, 'Tag', str_properties{i}, 'LineWidth', 2, ...
  %  'ButtonDownFcn', @(~, ~) btn_dwn_define_click(obj));
  
end

[indx, lowpass_freq, lowpass_t, highpass_freq, highpass_t] = ...
  paired_get_automatic_detection(t1, t2);

plot(highpass_t, highpass_freq, 'g')
%plot(lowpass_t, lowpass_freq, 'b', 'LineWidth', 2);
plot(xlim, mean(lowpass_freq)*[1 1], 'k--', 'LineWidth', 2);

plot(lowpass_t(indx([1:3 5:7])), lowpass_freq(indx([1:3 5:7])), 'ro', 'MarkerSize', 12, 'LineWidth', 2);
plot(highpass_t(indx(4)), highpass_freq(indx(4)), 'ro', 'MarkerSize', 12, 'LineWidth', 2);

xlim([-.5 .5])

title(obj.h_axes, [obj.neuron.file_tag ' ' num2str(obj.neuron_pair_indx) ' (2), ' ...
  obj.neuron.template_tag{obj.neuron_pair_indx} ' [' num2str(length(t1)) '], ' ...
  obj.neuron.template_tag{mod(obj.neuron_pair_indx, 2)+1} ' [' num2str(length(t2)) ']'], ...
  'Interpreter', 'none');

set(gcf, 'FileName', [obj.neuron.file_tag ' ' num2str(obj.neuron_pair_indx) ' (2), ' ...
  obj.neuron.template_tag{obj.neuron_pair_indx} ' [' num2str(length(t1)) '], ' ...
  obj.neuron.template_tag{mod(obj.neuron_pair_indx, 2)+1} ' [' num2str(length(t2)) '].png']);

save_as_png(gcf);

end