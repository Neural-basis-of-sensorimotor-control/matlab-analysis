% Constants

ec_pretrigger         = -1;
ec_posttrigger        = 1;
ec_kernelwidth        = 1e-3;
ec_min_stim_latency   = 5e-4;
ec_max_stim_latency   = .5;

isi_min_spike_latency = 0;
isi_max_spike_latency = .02;
isi_kernelwidth       = .001;
isi_tmax              = .1;

ic_pretrigger         = -.02;
ic_posttrigger        = .05;
ic_t_epsp_range       = [.0005 .002];
ic_t_spike_range      = [0 .002];

% Initialize
ec_neurons     = paired_get_extra_neurons();
ic_neurons     = paired_get_intra_neurons();
ic_toy_neurons = paired_get_experimental_ic_neurons();
