clear

set_current_settings_tag(get_default_settings_tag())

sc_clf_all();
reset_fig_indx();

% SPIKE ANALYSIS

% Constants

% Initialize
ec_neurons = paired_get_extra_neurons();

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
pretrigger = -.02;
posttrigger = .05;
t_range = [.0005 .0025];
% Initialize
ic_neurons = paired_get_intra_neurons();

% IC signal triggered on spike from paired neuron. Scaling from paired
% neuron channel removed

paired_plot_ic_signal(ic_neurons, pretrigger, posttrigger, t_range)

