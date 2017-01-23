function [pdf_isi_1, pdf_obs_t_forward, pdf_obs_t_back, pdf_predicted_t_forward] = ...
  get_pdf_paired_neuron_values(spiketimes1, spiketimes2, bintimes)

[isi1, spiketimes1] = get_isi(spiketimes1);

observed_t_fwd = get_t_forward(spiketimes1, spiketimes2);
observed_t_back = get_t_back(spiketimes1, spiketimes2);

pdf_isi_1 = histc(isi1, bintimes)/length(isi1);
pdf_obs_t_forward = histc(observed_t_fwd, bintimes)/length(observed_t_fwd);
pdf_obs_t_back = histc(observed_t_back, bintimes)/length(observed_t_back);

ind = bintimes > 0;

pdf_predicted_t_forward = zeros(size(bintimes));

p_isi = pds_isi_1(ind);
p_forw = pdf_obs_t_forward(ind);

p_back = zeros(size(pdf_isi));
p_back_tmp = pdf_obs_t_back(bintimes < 0);
p_back_tmp = p_back_tmp(length(p_back_tmp):-1:1);
p_back(1:length(p_back_tmp)) = p_back_tmp;
p_back(length(p_back)>length(p_isi)) = [];

pdf_predicted_t_forward(ind) = cumsum( p_back .* p_isi ./ cumsum(p_isi(length(p_isi):-1:1)));

end