function [pdf_isi_1, pdf_obs_t_forward, pdf_obs_t_back, pdf_predicted_t_forward] = ...
  get_pdf_paired_neuron_values(spiketimes1, spiketimes2, bintimes)
% Implementation of eq (2) Blot, (...), Léna: Time-invariant
% feed-forward inhibition of PC in the cerebellar cortex in vivo (Journal
% of Physiology 2016)
if std(diff(bintimes))>10*eps
  error('Input parameter bintimes must be evenly spaced');
end

[isi1, spiketimes1] = get_isi(spiketimes1);

observed_t_fwd = get_t_forward(spiketimes1, spiketimes2);
observed_t_back = get_t_back(spiketimes1, spiketimes2);

pdf_isi_1 = histc(isi1, bintimes);
pdf_isi_1 = pdf_isi_1 / sum(pdf_isi_1);

pdf_obs_t_forward = histc(observed_t_fwd, bintimes);
pdf_obs_t_forward = pdf_obs_t_forward / sum(pdf_obs_t_forward);

pdf_obs_t_back = histc(observed_t_back, bintimes);
pdf_obs_t_back = pdf_obs_t_back / sum(pdf_obs_t_back(:));

t0_min = 0;
[~, ind_t0_min] = min(abs(bintimes - t0_min));
ind_t0_max = length(bintimes);
[~, ind_t_zero] = min(abs(bintimes));

ind_t0_range = ind_t0_max - ind_t0_min;
pdf_predicted_t_forward = zeros(size(bintimes));

ind_t = ind_t_zero:(ind_t_zero+ind_t0_range);
dt = mean(diff(bintimes));

denominator = cumsum(pdf_isi_1(reverse_array(ind_t)));
denominator = reverse_array(denominator)*dt;
ind_t_back = ind_t_zero:-1:-ind_t0_range;
numerator1 = pdf_obs_t_back(ind_t_back(ind_t_back>0));
numerator1(end+1:ind_t0_range+1,:) = 0;

for tmp_ind=ind_t0_min:ind_t0_max
  ind_t_plus_t0 = tmp_ind:length(bintimes);
  numerator2 = pdf_isi_1(ind_t_plus_t0);
  numerator2(end+1:ind_t0_range+1,1) = 0;
  product_numerators = numerator1 .* numerator2;
  function_to_be_integrated = product_numerators ./ denominator;
  function_to_be_integrated(product_numerators == 0 & denominator == 0) = 0;
  
  pdf_predicted_t_forward(tmp_ind) = sum(function_to_be_integrated) * dt;
end

end

