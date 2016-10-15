classdef IntraAmplitudeViewer < handle
	
	methods
		
		function set_intra(obj, index)
			str = get_intra_motifs();
			tag = str{index};
			amplitudes = obj.main_channel.signal.amplitudes;
			obj.set_amplitude(amplitudes.get('tag', tag));
		end

		
		function next_intra(obj)
			current_amplitude = obj.amplitude;
			str = get_intra_motifs();
			indx = sc_cellfind(str, current_amplitude.tag);
			indx = mod(indx, length(str)) + 1
			obj.set_intra(indx);
		end
		
	end
	
end