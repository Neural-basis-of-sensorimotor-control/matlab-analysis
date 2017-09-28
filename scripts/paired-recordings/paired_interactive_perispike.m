function paired_interactive_perispike(neuron, pretrigger, posttrigger, ...
  kernelwidth)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_interactive_perispike, neuron, pretrigger, posttrigger, ...
  kernelwidth);

  return
  
end

binwidth = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(neuron);

f = incr_fig_indx();
clf

f.Name = neuron.file_tag;

h1 = subplot(1, 2, 1);

[f2, ~, h_plot] = sc_kernelhist(t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);

cr = ClickRecorder(h1, 6);
init_plot(cr);
grid on


assignin('base', 'click_recorder', cr);

h2 = subplot(1, 2, 2);
[f1, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);


linkaxes([h1 h2])

end
