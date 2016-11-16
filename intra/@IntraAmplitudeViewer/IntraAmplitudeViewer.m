classdef IntraAmplitudeViewer < handle
	
  properties
    neuron
  end
  
	methods
    
    function set_neuron(indx)
      
      if isnumeric(indx)
        obj.neuron = get_intra_neurons(indx);
      elseif ischar(indx)
        neurons = get_intra_neurons();
        obj.neuron = get_items(neurons, 'file_str', indx);
      end
      
      if isempty(obj.neuron)
        warning('Could not find neuron');
        return
      end
      
    end
		
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