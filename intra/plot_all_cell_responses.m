function plot_all_cell_responses()

neurons = get_intra_neurons();
stim_tags = get_intra_motifs();
 
rise_amplitudes = get_all_cell_response_values(neurons, stim_tags);
rise_amplitudes_indx = nan(size(rise_amplitudes));
rise_amplitudes_indx2 = nan(size(rise_amplitudes));

for i=1:size(rise_amplitudes, 1)
	x = rise_amplitudes(i,:);
	finite_vals = ~isempty(x) & isfinite(x);
	x = x(finite_vals);
	[~, ind] = sort(x);
	
	rise_amplitudes_indx(i, finite_vals) = ind;
	rise_amplitudes_indx2(i, finite_vals) = length(ind) - ind + 1;
end
	
for i=1:length(neurons)
	incr_fig_indx()
	clf
	
	subplot(121)
	hold on
	plot(1:length(stim_tags), rise_amplitudes_indx(:, i));
	set(gca, 'XTick', 1:length(stim_tags), 'XTickLabel', stim_tags);
	
	subplot(122)
	hold on
	plot(1:length(stim_tags), rise_amplitudes_indx2(:, i));
end