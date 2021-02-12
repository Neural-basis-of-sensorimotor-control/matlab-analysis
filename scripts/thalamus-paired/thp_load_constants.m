% Constants

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
ec_neurons     = thp_get_extra_neurons();
