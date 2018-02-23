classdef ScStim < ScChannel

  properties
    triggers
    istrigger
  end

  methods
    function obj = ScStim(parent, channelname,varargin)
      obj.parent  = parent;
      obj.channelname = channelname;
      obj.istrigger = false;
      for k=1:2:numel(varargin)
        obj.(varargin{k}) = varargin{k+1};
      end
    end

    function sc_loadtimes(obj)
      obj.triggers = ScList();
      if isempty(who('-file',obj.parent.filepath,obj.channelname))
        fprintf('Warning: Could not find channel %s in file %s\n',obj.channelname,obj.parent.filepath);
        return
      end
      d = load(obj.parent.filepath,obj.channelname);
      times = d.(obj.channelname).times;
      if isfield(d.(obj.channelname),'codes')
        codes = d.(obj.channelname).codes;
        uniquecodes = unique(codes,'rows');
        for i=1:size(uniquecodes,1)
          rows = all(codes == repmat(uniquecodes(i,:),size(codes,1),1),2);
          tag = num2str(uniquecodes(i,:));
          pos = isspace(tag);
          tag = tag(~pos);
          obj.triggers.add(ScSpikeTrain(tag,times(rows)));
        end
      else
        obj.triggers.add(ScSpikeTrain(obj.tag,times))
      end
    end

    function sc_clear(obj)
      obj.triggers = ScList;
    end
  end
  
  methods (Static)
    function obj = loadobj(a)
      obj = loadobj@ScChannel(a);
    end
  end
end
