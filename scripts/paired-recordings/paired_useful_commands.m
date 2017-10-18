% clear
% close all
% reset_fig_indx()
% paired_setup
% paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range, ic_double_trigger_isi)
% 
% 
% figs = get_all_figures(); for i=1:length(figs), figure(figs(i)); set(gca, 'FontSize', 12), end
% figs = get_all_figures(); for i=1:length(figs), figure(figs(i)); grid(gca, 'on'), end
% figs = get_all_figures(); for i=1:length(figs), figure(figs(i)); xlim(gca, [-2e-3 8e-3]), end
% 
% return
% clear
% close all
% reset_fig_indx()
% paired_setup
% indx1 = find(cellfun(@(x) strcmp(x, 'DGNR0005'), {ec_neurons.file_tag}));
% indx2 = find(cellfun(@(x) strcmp(x, 'CNNR0009'), {ec_neurons.file_tag}));
% x = NeuronBrowserClickRecorder(ec_neurons([indx1 indx2]));
% x.plot_neuron
% mxfigs
% return

% clear
% close all
% reset_fig_indx()
% paired_load_settings
% paired_load_constants
% paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range, ic_double_trigger_isi)
% mxfigs
% 
% return
% 
% clear
% close all
% reset_fig_indx()
% paired_load_settings
% paired_load_constants
% paired_plot_depth(ec_neurons);
% paired_mds(ec_neurons);
% mxfigs
% 
% add_legend(get_all_figures(), true)
% 
% plots = get_plots(get_all_figures());
% 
% for i=1:length(plots)
%   set(plots(i), 'LineWidth', 2);
% end
% 




clear
close all
reset_fig_indx()
paired_load_constants
paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_kernelwidth, ec_min_stim_latency, ec_max_stim_latency, ic_double_trigger_isi);
ax = get_axes(get_all_figures());

for i=1:length(ax)
  set(ax(i), 'FontSize', 12);
end

return
% %result = paired_vpd(ec_neurons(1:2), vpd_cost, vpd_time_range);
% %paired_perispike_summary(ec_neurons);
% paired_plot_depth(ec_neurons)
% return
% % mxfigs
% % brwfigs
% % % %% 
% clear
% close all
% reset_fig_indx()
% paired_load_settings
% paired_load_constants
% paired_plot_ic_signal(ic_neurons(3), ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range, ic_double_trigger_isi)
% paired_plot_unitary_epsp_response(ic_neurons(3), ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);
% return
% % % mxfigs
% % % brwfigs
% % % return
% % % %% 
% % % f = figure(4)
% % % neuron = paired_get_figure_neuron(f)
% % % 
% % % %% 
% % % mf = ModifyWaveform(gca, neuron, 'e-psp-p1-1')
% % % mf.init_plot

%% 
clear
close all
reset_fig_indx()
paired_load_constants

nbrws = NeuronBrowserClickRecorder(ec_neurons([26]));
nbrws.plot_neuron();
mxfigs

% save_as_png(gcf)
% 
% while true
%   nbrws.next_neuron()
%   set(gcf, 'FileName', [nbrws.neuron.file_tag '.png']);
%   set(gca, 'FontSize', 12);
%   save_as_png(gcf)
% end


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