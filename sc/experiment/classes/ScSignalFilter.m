classdef ScSignalFilter < ScFilter
  
  properties (SetObservable)
    
    parent
    scale_factor
    smoothing_width
    artifact_width
    artifactchannels
    
  end
  
  methods
    
    function obj = ScSignalFilter(parent)
      
      obj.scale_factor = 1;
      obj.smoothing_width = 5;
      obj.artifact_width = 0;
      obj.parent = parent;
      obj.artifactchannels = ScList();
      
    end
    
    
    function update(varargin)
    end
    
    
    function v = apply(obj, v)
      v = obj.filt(v, 0, inf);
    end
    
    
    %add all stim channels from parent file to artifact filter
    function update_stims(obj)
      stimchannels = obj.parent.parent.stims;
      for i=1:stimchannels.n
        stimchannel = stimchannels.get(i);
        if stimchannel.istrigger()
          obj.artifactchannels.add(stimchannel);
        elseif strcmp(stimchannel.tag,'DigMark')
          obj.artifactchannels.add(stimchannel.triggers.get('tag','1000'));
        else
          for j=1:stimchannel.triggers.n
            obj.artifactchannels.add(stimchannel.triggers.get(j));
          end
        end
      end
    end
    
    function v = filt(obj,v,tmin,tmax)
      v = obj.raw_filt(v);
      v = obj.artifact_removal(v,tmin,tmax);
    end
    
    function v = raw_filt(obj,v)
      v = obj.smoothing(v);
    end
    
    function v = smoothing(obj,v)
      if obj.scale_factor~=1
        v = v*obj.scale_factor;
      end
      v = filter(ones(1,obj.smoothing_width)/obj.smoothing_width,1,v);
    end
    
    function v = artifact_removal(obj,v,tmin,tmax)
      if obj.artifact_width
        for i=1:obj.artifactchannels.n
          stimtimes = obj.artifactchannels.get(i).gettimes(tmin,tmax);
          if numel(stimtimes)>=10
            stimpos = round((stimtimes-tmin)/obj.parent.dt)+1;
            v = sc_remove_artifacts(v,obj.artifact_width,stimpos);
          end
        end
      end
      
    end
    %         function v = dc_remove(obj,v)
    %             if obj.dc_remove_width>1
    %                 halfwidth = floor(obj.dc_remove_width/2);
    %           %      ind = halfwidth+1:(length(v)-halfwidth);
    %                 v0 = mean(v(1:obj.dc_remove_width));
    % %                 v(ind) = v(ind) + v0 + cumsum(v(ind+halfwidth)) - cumsum(v(ind-halfwidth));
    %                 n = length(v) - 2*halfwidth;
    %                 v([false(halfwidth,1); true(n,1); false(halfwidth,1)]) = ...
    %                     v([false(halfwidth,1); true(n,1); false(halfwidth,1)]) + ...
    %                     v0 + cumsum(v([false(2*halfwidth,1); true(n,1)])) - ...
    %                     cumsum(v([true(n,1); false(2*halfwidth,1)]));
    %             end
    % %            warning('debugging code')
    % %             obj.max_matrix_size = 1e9;
    % %             if obj.dc_remove_width>1
    % %                 v_filtered = v;
    % %                 halfwidth = floor(obj.dc_remove_width/2);
    % %                 incr = floor(obj.max_matrix_size/obj.dc_remove_width);
    % %                 startind = halfwidth+1:incr:(length(v)-halfwidth);
    % %                 stopind = [startind(2:end) (length(v)-halfwidth)];
    % %                 startind(startind>length(v)-halfwidth) = ones(find(startind>length(v)-halfwidth));
    % %                 stopind(stopind>length(v)-halfwidth) = ones(find(stopind>length(v)-halfwidth));
    % %                 for k=1:length(startind)
    % %                     ind = startind(k):stopind(k);
    % %                     inds = bsxfun(@plus,ind,(-halfwidth:halfwidth)');
    % %                     v_filtered(ind) = v(ind) - mean(v(inds),1)';
    % %                 end
    % %                 v = v_filtered;
    % %             end
    %         end
    
    function v = remove_waveforms(obj,v,tmin,tmax)
      rmwfs = obj.parent.get_rmwfs(tmin,tmax);
      for k=1:rmwfs.n
        v = rmwfs.get(k).remove_wf(v,0);
      end
    end
  end
  
  methods (Static)
    function obj = loadobj(obj)
      
      if isempty(obj.scale_factor)
        obj.scale_factor = 1;
      end
      
    end
  end
  
end
