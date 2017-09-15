function paired_define_minmax(neuron, pretrigger, posttrigger, kernelwidth)

binwidth = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(neuron);

f = incr_fig_indx();
clf
gca

f.Name = neuron.file_tag;

sc_kernelhist(t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);

grid on

cr = ClickRecorder(h_axes, 6);
init_plot(cr);

assignin('base', 'click_recorder', cr);


end