function [pdf_isi_1, pdf_obs_t_forward, pdf_obs_t_back, pdf_predicted_t_forward] = ...
  get_pdf_paired_neuron_values(spiketimes1, spiketimes2, bintimes)

[isi1, spiketimes1] = get_isi(spiketimes1);

observed_t_fwd = get_t_forward(spiketimes1, spiketimes2);
observed_t_back = get_t_back(spiketimes1, spiketimes2);

pdf_isi_1 = histc(isi1, bintimes);
pdf_isi_1 = pdf_isi_1 / sum(pdf_isi_1);

pdf_obs_t_forward = histc(observed_t_fwd, bintimes);
pdf_obs_t_forward = pdf_obs_t_forward / sum(pdf_obs_t_forward);

pdf_obs_t_back = histc(observed_t_back, bintimes);
pdf_obs_t_back = pdf_obs_t_back / sum(pdf_obs_t_back(:));

ind = bintimes > 0;

pdf_predicted_t_forward = zeros(size(bintimes));

p_isi = pdf_isi_1(ind);

p_back = zeros(size(p_isi));
p_back_tmp = pdf_obs_t_back(bintimes < 0);
p_back_tmp = p_back_tmp(length(p_back_tmp):-1:1);
p_back(1:length(p_back_tmp)) = p_back_tmp;
p_back(length(p_back)>length(p_isi)) = [];

indx = find(ind);
indx0 = min(indx)-1;

for i=1:(length(indx)-1)
  pdf_predicted_t_forward(indx(i)) = p_prediction(indx-indx0, indx(i)-indx0);
end

  function val = p_prediction(t_ind, t0_ind)
    
    val = p_back(t_ind) .* p_isi(t_ind + t0_ind) ./ sum( p_isi(t_ind:end));
    
  end

end

