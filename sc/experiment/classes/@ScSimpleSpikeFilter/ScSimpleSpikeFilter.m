classdef ScSimpleSpikeFilter < ScSimpleFilter
  
  methods
    
    function obj = ScSimpleSpikeFilter(parent)
      obj@ScSimpleFilter(parent);
    end
    
    function artifact_indx = get_filter_indx(obj)
      
      indx = startswithi(obj.parent.waveforms.values('tag'), 'spike');
      waveforms = obj.parent.waveforms.cell_list(indx);
      
      artifact_times = nan(1000, 1);
      count = 0;
      
      for i=1:length(waveforms)
        
        waveform = waveforms{i};
        
        times = waveform.gettimes(0, inf);
        artifact_times(count+(1:length(times))) = times;
        count = count + length(times);
        
      end
      
      artifact_times = artifact_times(1:count);
      
      artifact_indx = round(artifact_times/obj.parent.dt);
      
    end
  end

end