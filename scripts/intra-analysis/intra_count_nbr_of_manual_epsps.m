clear
close all
reset_fig_indx()
sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);
sc_debug.set_recursive_depth(2);

intra_load_constants
stims = get_intra_motifs();

% nbr_of_manual_amplitudes = 0;
% tot_nbr_of_amplitudes    = 0;
%
% for i=1:length(neurons)
%
%   sc_debug.print(i, length(neurons))
%
%   signal = sc_load_signal(neurons(i));
%
%   for j=1:length(stims)
%
%     amplitude = signal.amplitudes.get('tag', stims{j});
%     nbr_of_manual_amplitudes = nbr_of_manual_amplitudes + nnz(amplitude.valid_data);
%     tot_nbr_of_amplitudes = tot_nbr_of_amplitudes + length(amplitude.valid_data);
%
%   end
% end
%
% nbr_of_manual_amplitudes
% tot_nbr_of_amplitudes
%
% single_pulses = {'1p electrode 1'
%   '1p electrode 2'
%   '1p electrode 3'
%   '1p electrode 4'};
%
% nbr_of_manual_stim_amplitudes = 0;
% tot_nbr_of_stim_amplitudes    = 0;
%
% for i=1:length(neurons)
%
%   sc_debug.print(i, length(neurons))
%
%   signal = sc_load_signal(neurons(i));
%
%   for j=1:length(single_pulses)
%
%     for k=1:4
%
%       for m=1:100
%
%         stim_str = [single_pulses{j} '#V' num2str(k) '#' num2str(m)];
%         amplitude = signal.amplitudes.get('tag', stim_str);
%
%         if isempty(amplitude)
%           continue;
%         end
%
%         nbr_of_manual_stim_amplitudes = nbr_of_manual_stim_amplitudes + nnz(amplitude.valid_data);
%         tot_nbr_of_stim_amplitudes = tot_nbr_of_stim_amplitudes + length(amplitude.valid_data);
%
%       end
%
%     end
%
%   end
%
% end
%
% nbr_of_manual_stim_amplitudes
% tot_nbr_of_stim_amplitudes
%
% %%
% total_time = 0;
%
% for i=1:length(neurons)
%
%   sc_debug.print(i, length(neurons))
%
%   signal = sc_load_signal(neurons(i));
%   total_time = total_time + signal.N * signal.dt;
%
% end
%
% total_time
% total_time/60
% total_time/3600

manual_automatic = 0;
manual_not_atomatic    = 0;
not_manual_automatic = 0;
not_manual_not_automatic = 0;

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons))
  
  signal = sc_load_signal(neurons(i));
  
  for j=1:length(stims)
    
    amplitude = signal.amplitudes.get('tag', stims{j});
    
    tmp_manual    = amplitude.userdata.fraction_detected >= intra_get_activity_threshold(signal);
    tmp_automatic = nnz(amplitude.valid_data) >= 2;
    
    if tmp_manual && tmp_automatic
      manual_automatic = manual_automatic + 1;
    elseif tmp_manual
      manual_not_automatic = manual_not_atomatic + 1;
    elseif tmp_automatic
      not_manual_automatic = not_manual_automatic + 1;
    else
      not_manual_not_automatic = not_manual_not_automatic + 1;
    end
    
  end
end

manual_automatic
manual_not_atomatic
not_manual_automatic
not_manual_not_automatic
  
