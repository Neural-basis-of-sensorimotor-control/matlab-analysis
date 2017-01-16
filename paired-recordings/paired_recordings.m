clc
clear
clf reset

pretrigger = -.5;
posttrigger = .5;
binwidth = 1e-3;
bintimes = pretrigger:binwidth:posttrigger;

signal = sc_load_signal(get_intra_neurons(2));

neuron1 = signal.waveforms.get(1);
neuron2 = signal.waveforms.get(2);

[isi_1, spiketimes_1] = get_isi(neuron1);
[isi_2, spiketimes_2] = get_isi(neuron2);

observed_t_fwd = get_t_forward(spiketimes_1, spiketimes_2);
observed_t_back = get_t_back(spiketimes_1, spiketimes_2);

pdf_isi_1 = histc(isi_1, bintimes)/length(isi_1);
pdf_obs_t_forward = histc(observed_t_fwd, bintimes)/length(observed_t_fwd);
pdf_obs_t_back = histc(observed_t_back, bintimes)/length(observed_t_back);

hold on
plot(bintimes, pdf_isi_1, 'Tag', 'ISI');
plot(bintimes, pdf_obs_t_forward, 'Tag', 'Observed t_f_o_r_w_a_r_d');
plot(bintimes, pdf_obs_t_back, 'Tag', 'Observed t_b_a_c_k');
add_legend
%axis tight