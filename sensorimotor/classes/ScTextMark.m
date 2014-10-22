classdef ScTextMark < ScChannel & ScTriggerParent
    
    methods
        function obj = ScTextMark(parent, channelname,varargin)
            obj.parent = parent;
            obj.channelname = channelname;
            obj.triggers = ScList;
            for k=1:2:numel(varargin)
                obj.(varargin{k}) = varargin{k+1};
            end
        end

        %Load digital channel values
        function sc_loadtimes(obj)
            obj.triggers = ScList;
            if isempty(who('-file',obj.parent.filepath,obj.channelname))
                fprintf('Warning: Could not find channel %s in file %s\n',obj.channelname,obj.parent.filepath);
                return
            end
            d = load(obj.parent.filepath,obj.channelname);
            if isfield(d.(obj.channelname),'text')
                times = d.(obj.channelname).times;
                text = d.(obj.channelname).text;
                cellstr = cell(size(times));
                for i=1:numel(cellstr)
                    cellstr(i) = {deblank(text(i,:))};
                end
                tags = unique(cellstr);
                obj.triggers = ScList;
                for i=1:numel(tags)
                    pos = cellfun(@(x) strcmp(x,tags{i}), cellstr);
                    tagtimes = times(pos);
                    if obj.parent.stims.has('tag','DigMark')
                        digmarktimes = obj.parent.stims.get('tag','DigMark').triggers.get('tag','1000').gettimes(-inf,inf);
                        for j=1:numel(tagtimes)
                            [~,ind] = min(abs(tagtimes(j)-digmarktimes));
                            tagtimes(j) = digmarktimes(ind);
                        end
                    end
                    obj.triggers.add(ScSpikeTrain(tags{i},tagtimes));
                end
            end
        end
        
    end
end