function plot_paired_recordings(paired_neurons, pretrigger, posttrigger, ...
  binwidth)

if ~exist('pretrigger', 'var')
  pretrigger = -.5;
end

if ~exist('posttriger', 'var')
  posttrigger = .5;
end

if ~exist('binwidth', 'var')
  binwidth = 1e-3;
end

bintimes = pretrigger:binwidth:posttrigger;

[spiketimes1, spiketimes2, waveform1, waveform2] = get_paired_neurons_spiketimes(paired_neurons);

[pdf_isi_1, pdf_obs_t_forward_1, pdf_obs_t_back_1, pdf_predicted_t_forw_1] = ...
  get_pdf_paired_neuron_values(spiketimes1, spiketimes2, bintimes);

[pdf_isi_2, pdf_obs_t_forward_2, pdf_obs_t_back_2, pdf_predicted_t_forw_2] = ...
  get_pdf_paired_neuron_values(spiketimes2, spiketimes1, bintimes);

subplot(121)
plot_result(pdf_isi_1, pdf_obs_t_forward_1, pdf_obs_t_back_1, pdf_predicted_t_forw_1, ...
  waveform1.tag, waveform2.tag)

subplot(122)
plot_result(pdf_isi_2, pdf_obs_t_forward_2, pdf_obs_t_back_2, pdf_predicted_t_forw_2, ...
  waveform2.tag, waveform1.tag)

add_legend(gcf, true);

  function plot_result(pdf_isi, pdf_obs_t_forward, pdf_obs_t_back, ...
      pdf_predicted_t_forward, tag1, tag2)
    
    hold on
    plot(bintimes, pdf_isi, 'Tag', 'ISI');
    plot(bintimes, pdf_obs_t_forward, 'Tag', 'Observed t_f_o_r_w_a_r_d');
    plot(bintimes, pdf_obs_t_back, 'Tag', 'Observed t_b_a_c_k');
    plot(bintimes, pdf_predicted_t_forward, 'Tag', 'Predicted t_f_o_r_w_a_r_d');
    
    title([paired_neurons.file_tag ': ' tag1 ' - ' tag2]) 
    
  end

end


