clear
close all
reset_fig_indx()
paired_load_constants
%result = paired_vpd(ec_neurons(1:2), vpd_cost, vpd_time_range);
%paired_perispike_summary(ec_neurons);

mxfigs
brwfigs
% %% 
% clear
% close all
% reset_fig_indx()
% paired_load_constants
% paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range)
% paired_plot_unitary_epsp_response(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);
% mxfigs
% brwfigs
% return
% %% 
% f = figure(4)
% neuron = paired_get_figure_neuron(f)
% 
% %% 
% mf = ModifyWaveform(gca, neuron, 'e-psp-p1-1')
% mf.init_plot

% %% 
% clear
% close all
% reset_fig_indx()
% paired_load_constants
% 
% nbrws = NeuronBrowserClickRecorder(ec_neurons);
% nbrws.plot_neuron();
% 
% return
% %% 
% f = figure(4)
% neuron = paired_get_figure_neuron(f)
% 
% %% 
% mf = ModifyWaveform(gca, neuron, 'e-psp-p1-1')
% mf.init_plot