clc
close all
clear classes
reset_fig_indx();

sc_settings.set_current_settings_tag(sc_settings.tags.HANNES)
sc_debug.set_mode(true);
plot_only_final_figures = true;
ec_pretrigger         = -1;
ec_posttrigger        = 1;
ec_kernelwidth        = 1e-3;
ec_min_stim_latency   = 5e-4;
ec_max_stim_latency   = .2;

vpd_cost              = 1;
vpd_time_range        = [0 1] + .0002;

isi_min_spike_latency = 0;
isi_max_spike_latency = .02;
isi_kernelwidth       = .001;
isi_tmax              = .1;

ic_pretrigger         = -.04;
ic_posttrigger        = .05;
ic_t_epsp_range       = [.0005 .002];
ic_t_spike_range      = [0 .002];
ic_double_trigger_isi = .01;

% Initialize
ec_neurons     = paired_get_extra_neurons();
ic_neurons     = paired_get_intra_neurons();


% SPIKE ANALYSIS

% Cross correlation / perispike event histogram

% Figure 1 + 4 Spike-triggered histogram (SpTH) for paired neurons

paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_kernelwidth, ec_min_stim_latency, ec_max_stim_latency, isi_min_spike_latency);

% Figure 2 Parameters from figure 1 plotted vs neuron depth
paired_plot_depth(ec_neurons);

paired_mds(ec_neurons);

if ~plot_only_final_figures
  paired_conditional_isi(ec_neurons, ec_min_stim_latency, ec_max_stim_latency, isi_min_spike_latency, isi_max_spike_latency, isi_kernelwidth, isi_tmax)
end

%paired_vpd(ec_neurons, vpd_cost, vpd_time_range);

% Raster plots for each pattern & for paired neuron

% Perievent spiking histogram / perievent pattern histogram

% Perievent spiking KDE / perievent pattern KDE

% MDS performed on KDE for each cell separated on pattern and on paired
% neuron spiking

% Interneuronal difference between cell KDEs, separated on pattern and on
% paired neuron spiking (?)

% KDE autocorrelation, and crosscorrelation between paired neurons

% ISI, separated in two groups: i) when preceeded by paired neuron spike,
% and ii) when not preceeded by paired neuron spike

% (unclear) Perievent stimulus histogram, separated depending on whether
% there is activity in paired neuron

% (unclear) latency to first spike post-pattern onset, depending on whether
% there is a spike in paired neuron

% Fig 4 in Time?invariant feed?forward inhibition of Purkinje cells in the
% cerebellar cortex in vivo (eq. 2)

% IC ANALYSIS

% IC signal triggered on spike from paired neuron. Scaling from paired
% neuron channel removed

paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range, ic_double_trigger_isi)

if ~plot_only_final_figures
  
  paired_plot_unitary_epsp_response(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);
  apply_to_figs(@zoom, 'on')

end