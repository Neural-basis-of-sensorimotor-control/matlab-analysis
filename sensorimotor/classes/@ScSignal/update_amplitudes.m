function update_amplitudes(obj, response_min, response_max, remove_fraction)

stims = get_intra_motifs();

v = obj.sc_loadsignal();

for i=1:length(stims)
	amplitude = obj.amplitudes.get('tag', stims{i});
	
	if ~amplitude.is_updated
		amplitude.update(v, response_min, response_max, remove_fraction);
	end
	
end

end