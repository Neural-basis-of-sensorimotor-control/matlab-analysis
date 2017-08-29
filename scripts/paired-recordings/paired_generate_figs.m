clear

set_current_settings_tag(get_default_settings_tag())

sc_clf_all();
reset_fig_indx();

% SPIKE ANALYSIS

% Constants
ec_pretrigger         = -.1;
ec_posttrigger        = .1;
ec_binwidth           = 1e-3;
ec_min_stim_latency   = 5e-4;
ec_max_stim_latency   = .5;

% Initialize
ec_neurons = paired_get_extra_neurons();

% Cross correlation / perispike event histogram
paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_binwidth, ...
  ec_min_stim_latency, ec_max_stim_latency);
return






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

% Constants
ic_pretrigger = -.02;
ic_posttrigger = .05;
ic_t_range = [.0005 .0025];
% Initialize
ic_neurons = paired_get_intra_neurons();

% IC signal triggered on spike from paired neuron. Scaling from paired
% neuron channel removed

paired_plot_ic_signal(ic_neurons, ic_pretrigger, ic_posttrigger, ic_t_range)

