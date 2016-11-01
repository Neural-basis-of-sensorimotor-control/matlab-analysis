classdef ScSimpleArtifactFilter < handle
  
  properties
    parent
    indx_width = 100
    is_on = true
  end
  
  methods
    
    function obj = ScSimpleArtifactFilter(parent)
      obj.parent = parent;
    end
    
    
    function v = apply(obj, v)
      if ~obj.is_on
        return
      end
      
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
        
      v = simple_artifact_filter(v, obj.indx_width, artifact_indx);
    end
    
    
  end
end