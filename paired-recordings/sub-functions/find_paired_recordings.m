clear

paired_rec_indx = 2;


load pairedrecordings.mat

% 
% max_inactivity_time = 10;
% min_nbr_of_spikes_per_sequence = 5;
% min_time_span_per_sequence = 2;
% 
% directory = ['D:' filesep 'temp' filesep 'analyzed_data' filesep];
% 
% files = List(1000);
% 
% for i=1:10
%   s = rdir([directory '*.dat']);
%   names = {s.name};
%   
%   for j=1:length(names)
%     add(files, names(j));
%   end
%   
%   directory = [directory '*' filesep]; %#ok<AGROW>
% end
% 
% spiketrains = List(1000);
% add_spiketrains(files, spiketrains);
% 
% overlapping_spiketrains = List(1000);
% add_coupled_spiketrains(spiketrains, max_inactivity_time, ...
%   min_nbr_of_spikes_per_sequence, min_time_span_per_sequence, ...
%   overlapping_spiketrains);
% remove_identical_spiketrains(overlapping_spiketrains);
% remove_identical_spiketrain_pairs(overlapping_spiketrains);

% correct_experiment_filename(overlapping_spiketrains);
% add_experiment_reference(overlapping_spiketrains);

% plot_raster_paired_recordings(overlapping_spiketrains, vals(overlapping_spiketrains, 'time_sequences'), 'overlapping activity');
% 
% plot_raster_paired_recordings(overlapping_spiketrains, vals(overlapping_spiketrains, @get_touch_pattern_time_sequences), 'touch patterns');
% 
% plot_raster_paired_recordings(overlapping_spiketrains, vals(overlapping_spiketrains, @get_spont_activity_time_sequences), 'spontaneous activity');

tmp_pair = overlapping_spiketrains(paired_rec_indx);

tmp_pair.load_experiment();


