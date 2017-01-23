clc
clear
clf reset

exclude_neurons = {'DJNR0005', 'HRNR0000', 'BJNR0005'};%{'HPNR0003', 'DJNR0005'};%{'CANR0001', 'DJNR0005', 'CANR0008'};
scaling_dim = 2;

neurons = get_intra_neurons();
neurons = rm_from_list(neurons, 'file_tag', exclude_neurons);

stims_str = get_intra_motifs();

amplitude_values = nan(length(stims_str), 1000);
neuron_tags = cell(1000, 1);

count = 0;

for i=1:length(neurons)
	
  fprintf('%d (%d)\n', i, length(neurons))
  
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron);
  stims = get_items(signal.amplitudes.list, 'tag', stims_str);
  is_response = generate_response_matrix(signal, stims_str);
  
%   min_nbr_of_stims = min(cell2mat(get_values(stims(is_response), ...
%     @(x) nnz(x.valid_data))));

  min_nbr_of_stims = mean(cell2mat(get_values(stims(is_response), ...
    @(x) nnz(x.valid_data))));
  
  for j=1:min_nbr_of_stims
    count = count + 1;
    neuron_tags(count) = {neuron.file_tag};
    
    for k=1:length(stims)
      
      if ~is_response(k)
        amplitude_values(k, count) = 0;
      else
        stim = stims(k);
				
				if j>length(stim.height)
					amplitude_values(k, count) = 0;
				else
% 					[~, electrode_ind] = get_electrode(stim.tag);
% 					
% 					amplitude_values(k, count) = stim.height(j)/...
% 						signal.userdata.single_pulse_height(electrode_ind);

% 					[~, electrode_ind] = get_electrode(stim.tag);
% 					
% 					amplitude_values(k, count) = stim.width(j)/...
% 						signal.userdata.single_pulse_width(electrode_ind);
% 					
					
					[~, electrode_ind] = get_electrode(stim.tag);
					
					amplitude_values(k, count) = stim.latency(j)/...
						signal.userdata.single_pulse_latency(electrode_ind);
				end
      end
    end
  end
end

amplitude_values = amplitude_values(:, 1:count);
neuron_tags = neuron_tags(1:count);

%% Perform MDS
d = pdist(amplitude_values');
y = mdscale(d, scaling_dim);

subplot(121)
plot_mda(y, neuron_tags);
title('Non-linear MDS');

y = cmdscale(d, scaling_dim);

subplot(122)
plot_mda(y, neuron_tags);
title('Classical MDS');

add_legend([subplot(121) subplot(122)], true);