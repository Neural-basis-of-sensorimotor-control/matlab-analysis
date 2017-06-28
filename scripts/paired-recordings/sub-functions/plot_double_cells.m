% clc
% clear
% sc_clf_all
% reset_fig_indx
%
% max_inactivity_time = 10;
% min_nbr_of_spikes_per_sequence = 5;
% min_time_span_per_sequence = 2;
%
% double_cell = ScNeuron('experiment_filename', 'BMNR_SSSA_sc.mat', ...
%   'file_tag', 'BMNR0000', 'signal_tag', 'patch', 'template_tag', ...
%   {'spike1-double', 'spike2-double'}, 'tag', 'BMNR_SSSA-double-1');
%
% % double_cell = ScNeuron('experiment_filename', 'BKNR_sc.mat', ...
% %   'file_tag', 'BKNR0000', 'signal_tag', 'patch', 'template_tag', ...
% %   {'spike1-double', 'spike2-double'}, 'tag', 'BKNR-double-1');
%
% signal = sc_load_signal(double_cell);
%
% waveform1 = signal.waveforms.get('tag', double_cell.template_tag{1});
% waveform2 = signal.waveforms.get('tag', double_cell.template_tag{2});
%
% spiketimes1 = waveform1.gettimes(double_cell.tmin, double_cell.tmax);
% spiketimes2 = waveform2.gettimes(double_cell.tmin, double_cell.tmax);
%
% double_cell.time_sequences = find_time_sequences(spiketimes1, spiketimes2, ...
%   max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
%   min_time_span_per_sequence);
%
% % double_cell.time_sequences = extract_time_sequence_disjunction...
% %   (get_sequence(spiketimes1, max_inactivity_time), ...
% %   get_sequence(spiketimes2, max_inactivity_time));
%
% % double_cell.time_sequences = extract_time_sequence_conjunction...
% %   (get_sequence(spiketimes1, max_inactivity_time), ...
% %   get_sequence(spiketimes2, max_inactivity_time));
%
% % double_cell.time_sequences = get_sequence(spiketimes1, max_inactivity_time);
%
% %double_cell.time_sequences = get_sequence(spiketimes2, max_inactivity_time);
%
% plot_raster_paired_recordings(double_cell, double_cell.time_sequences, ...
%   'overlapping activity');
%
% max_latency = [.001 .01 .1 .2 .4 1];
% response_1 = cell(size(max_latency));
% spont_1 = cell(size(max_latency));
% response_2 = cell(size(max_latency));
% spont_2 = cell(size(max_latency));
% 
% count = 0;
% 
% for x = max_latency
%   
%   count = count + 1;
%   [tmp_response_1, tmp_spont_1, tmp_response_2, tmp_spont_2] = plot_double_cell_cross_corr(double_cell, 'pretrigger', -1, 'posttrigger', 2, ...
%     'max_latency', x);
%   
%   response_1(count) = {tmp_response_1};
%   spont_1(count) = {tmp_spont_1};
%   
%   response_2(count) = {tmp_response_2};
%   spont_2(count) = {tmp_spont_2};
%   
% end


incr_fig_indx()
clf
yticklabel = sprintf('min latency = 0.5 ms, max latency = %d ms\n', 1000*max_latency);
ytick = 1:length(max_latency);

for i=1:length(max_latency)
  
  subplot(1,2,1)
  hold on
  tmp_response = response_1{i};
  plot(tmp_response, i*ones(size(tmp_response)), '+', 'Tag', 'Response activity')
  tmp_spont = spont_1{i};
  plot(tmp_spont, i*ones(size(tmp_spont)), '+', 'Tag', 'Spont activity')
  
  subplot(1,2,2)
  hold on
  tmp_response = response_2{i};
  plot(tmp_response, i*ones(size(tmp_response)), '+', 'Tag', 'Response activity')
  tmp_spont = spont_2{i};
  plot(tmp_spont, i*ones(size(tmp_spont)), '+', 'Tag', 'Spont activity')
  
end

add_legend(gcf, true);

for i=get_axes(gcf)
  
  set(i, 'YTick', ytick, 'YTickLabel', yticklabel);
  xlabel(i, 'Log [activity_(_p_r_e_s_y_n_a_p_t_i_c _s_p_i_k_e_) / activity_(_n_o _p_r_e_s_y_n_a_p_t_i_c _s_p_i_k_e_)]');
  ylim(i, [0.5 (length(max_latency))+.5]);
  set(i, 'Color', 'k')
end



