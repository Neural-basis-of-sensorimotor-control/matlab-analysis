function plot_cell_responses(obj, ax)

cla(ax);

str = get_intra_motifs();

for i=1:length(str)
	amplitude = obj.amplitudes.get('tag', str{i});
	
	x = amplitude.rise_automatic_detection;
	y = i*ones(size(x));
	
	plot(x, y, '.');

end

set(ax, 'YTick', 1:length(str), 'YTick', str);
title(ax, obj.parent.tag);

end