%% 
clear
close all
reset_fig_indx()
paired_load_constants
paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range)
paired_plot_unitary_epsp_response(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);
mxfigs
brwfigs

%% 
f = figure(2)
neuron = paired_get_figure_neuron(f)

%% 
mf = ModifyWaveform(gca, neuron, 'remove-spike-1')
mf.init_plot