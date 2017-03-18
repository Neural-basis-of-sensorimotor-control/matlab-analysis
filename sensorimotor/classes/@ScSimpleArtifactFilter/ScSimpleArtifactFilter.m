classdef ScSimpleArtifactFilter < ScSimpleFilter
  
  methods
    
    function obj = ScSimpleArtifactFilter(parent)
      obj@ScSimpleFilter(parent);
    end
    
    function artifact_indx = get_filter_indx(obj)
      stims = obj.parent.parent.stims;
      artifact_times = nan(1000, 1);
      count = 0;
      
      for i=1:stims.n
        stim = stims.get(i);
        triggers = stim.triggers;
        
        for j=1:triggers.n
          times = triggers.get(j).gettimes(0, inf);
          artifact_times(count+(1:length(times))) = times;
          count = count + length(times);
        end
      end
      artifact_times = artifact_times(1:count);
      
      artifact_indx = round(artifact_times/obj.parent.dt);
    end
  end
  
end