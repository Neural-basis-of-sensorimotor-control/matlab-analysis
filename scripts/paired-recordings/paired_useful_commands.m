% clear
% close all
% reset_fig_indx()
% paired_load_constants
% %result = paired_vpd(ec_neurons(1:2), vpd_cost, vpd_time_range);
% %paired_perispike_summary(ec_neurons);
% 
% mxfigs
% brwfigs
% % %% 
clear
close all
reset_fig_indx()
paired_load_settings
paired_load_constants
paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range, ic_double_trigger_isi)
return
% % paired_plot_unitary_epsp_response(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);
% % mxfigs
% % brwfigs
% % return
% % %% 
% % f = figure(4)
% % neuron = paired_get_figure_neuron(f)
% % 
% % %% 
% % mf = ModifyWaveform(gca, neuron, 'e-psp-p1-1')
% % mf.init_plot

%% 
clear
close all
reset_fig_indx()
paired_load_constants

nbrws = NeuronBrowserClickRecorder(ec_neurons);
nbrws.plot_neuron();
mxfigs

save_as_png(gcf)

while true
  nbrws.next_neuron()
  set(gcf, 'FileName', [nbrws.neuron.file_tag '.png']);
  set(gca, 'FontSize', 12);
  save_as_png(gcf)
end


return

clear
close all
reset_fig_indx()
paired_load_constants

paired_plot_depth(ec_neurons);

mxfigs
return
%% 
f = figure(4)
neuron = paired_get_figure_neuron(f)

%% 
mf = ModifyWaveform(gca, neuron, 'e-psp-p1-1')
mf.init_plot