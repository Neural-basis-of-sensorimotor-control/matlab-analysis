set_current_settings_tag(get_default_settings_tag())

%reset_fig_indx();

paired_load_constants();

% SPIKE ANALYSIS

% Cross correlation / perispike event histogram

% Figure 1 + 4 Spike-triggered histogram (SpTH) for paired neurons

paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_kernelwidth, ec_min_stim_latency, ec_max_stim_latency);

% Figure 2 Parameters from figure 1 plotted vs neuron depth

paired_plot_depth(ec_neurons);

paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_kernelwidth, ec_min_stim_latency, ec_max_stim_latency);

paired_conditional_isi(ec_neurons, ec_min_stim_latency, ec_max_stim_latency, isi_min_spike_latency, isi_max_spike_latency, isi_kernelwidth, isi_tmax)

paired_perispike_summary(ec_neurons);

paired_vpd(ec_neurons, vpd_missing_spike_weight, vpd_cost);

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

paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range)
paired_plot_unitary_epsp_response(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_epsp_range, ic_t_spike_range);

apply_to_figs(@zoom, 'on')
