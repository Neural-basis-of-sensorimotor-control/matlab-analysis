function [pdf_isi_1, pdf_obs_t_forward, pdf_obs_t_back] = ...
  get_pdf_paired_neuron_values(spiketimes1, spiketimes2, bintimes)

[isi1, spiketimes1] = get_isi(spiketimes1);

observed_t_fwd = get_t_forward(spiketimes1, spiketimes2);
observed_t_back = get_t_back(spiketimes1, spiketimes2);

pdf_isi_1 = histc(isi1, bintimes)/length(isi1);
pdf_obs_t_forward = histc(observed_t_fwd, bintimes)/length(observed_t_fwd);
pdf_obs_t_back = histc(observed_t_back, bintimes)/length(observed_t_back);

end