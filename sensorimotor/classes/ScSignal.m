classdef ScSignal < ScChannel
    %Analog imported channel
    properties
        dt                  %time resolution (1x1 double)
        waveforms           %ScWaveform
        filter              %ScSignalFilter
        remove_waveforms    %ScRemoveWaveformList
        N                   %nbr of data points (1x1 double)
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
            obj.remove_waveforms = ScList();
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
                v_raw = fread(fid,obj.N,'bit12',4);
                fclose(fid);
            else
                if isempty(who('-file',obj.parent.filepath,obj.channelname))
                    msgbox('Error: Could not find channel %s in file %s\n',obj.channelname,obj.parent.filepath);
                    return
                end
                d = load(obj.parent.filepath,obj.channelname);
                obj.dt = d.(obj.channelname).interval;
                obj.N = d.(obj.channelname).length;%numel(obj.v_raw);
                v_raw = d.(obj.channelname).values;%(t>tmin & t<tmax);
            end
        end
        
        %Recalculate all waveform times with correct order vs filtering
        function recalculate_all_waveforms(obj)
            v = obj.filter.filt(obj.sc_loadsignal(),0,inf);
            for k=1:obj.remove_waveforms.n
                rmwf = obj.remove_waveforms.get(k);
                rmwf.calibrate(v);
                v = rmvf.remove_artifacts(v);
            end
            for k=1:obj.waveforms.n
                wf = obj.waveforms.get(k);
                wf.recalculate_spiketimes(v,obj.dt);
            end
        end
        
        function rmwfs = get_rmwfs(obj,tmin,tmax)
            rmwfs = ScList();
            for k=1:obj.remove_waveforms.n
                rmwf = obj.remove_waveforms.get(k);
                if rmwf.tstart<tmax && rmwf.tstop>=tmin
                    rmwfs.add(rmwf);
                end
            end
        end
        function istrigger = get.istrigger(~)
            istrigger = false;
        end
        
        function triggers = get.triggers(obj)
            triggers = ScCellList();
            for k=1:obj.waveforms.n
                triggers.add(obj.waveforms.get(k));
            end
            for k=1:obj.remove_waveforms.n
                triggers.add(obj.remove_waveforms.get(k));
            end
        end
        
        function t = get.t(obj)
            t = (0:obj.N-1)'*obj.dt;
        end
    end
    methods (Static)
        function obj = loadobj(a)
            a = loadobj@ScChannel(a);
            if isempty(a.remove_waveforms)
                a.remove_waveforms = ScList();
            end
            obj = a;
        end
    end
end
