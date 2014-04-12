classdef ScSignal < ScChannel
    %Analog imported channel
    properties
        dt          %time resolution (1x1 double)
        waveforms   %ScWaveform
        filter      %ScFilter
        N           %nbr of data points (1x1 double)
    end
    
    properties (Dependent)
        t
        istrigger
        triggers
    end
    
    methods
        function obj = ScSignal(parent,channelname,varargin)
            obj.parent = parent;
            obj.channelname = channelname;
            obj.waveforms = ScList;
            obj.filter = ScSignalFilter(obj);
            for k=1:2:numel(varargin)
                obj.(varargin{k}) = varargin{k+1};
            end
        end
        
        %Clear all properties
        function sc_clear(obj)
            for i=1:obj.waveforms.n
                obj.waveforms.get(i).sc_clear();
            end
        end
        
        %Load non-transient properties
        function sc_loadtimes(obj)
            for i=1:obj.waveforms.n
                obj.waveforms.get(i).sc_loadtimes();
            end
        end
        
        %Load transient properties (only)
        function v_raw = sc_loadsignal(obj)%,tmin,tmax)
            if obj.is_adq_file
                fid = fopen(obj.parent.filepath);
                fread(fid,obj.channelname,'uint16');
                v_raw = fread(fid,obj.N,'uint16');
                fclose(fid);
            else
                d = load(obj.parent.filepath,obj.channelname);
                obj.dt = d.(obj.channelname).interval;
                obj.N = d.(obj.channelname).length;%numel(obj.v_raw);
                v_raw = d.(obj.channelname).values;%(t>tmin & t<tmax);
            end
        end
        
        function istrigger = get.istrigger(~)
            istrigger = false;
        end
        
        function triggers = get.triggers(obj)
            triggers = obj.waveforms;
        end
        
        function t = get.t(obj)
            t = (0:obj.N-1)'*obj.dt;
        end
    end
end
