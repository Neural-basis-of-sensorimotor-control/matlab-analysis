classdef WaveformViewer < SequenceViewer
    
    properties (SetObservable)
        triggerparent
        trigger
        waveform
    end
    
    properties (Dependent)
        triggerparents
        triggers
        triggertimes
    end
    
    methods (Static)
        function enum = mode
            enum = ScGuiState.spike_detection;
        end
    end
    
    methods
        function obj = WaveformViewer(guimanager,varargin)
            obj@SequenceViewer(guimanager,varargin{:});
            obj.dbg_in(mfilename,'WaveformViewer()');
            addlistener(obj,'triggerparent','PostSet',@(~,~) obj.triggerparent_listener);            
            obj.dbg_out(mfilename,'WaveformViewer()');
        end
        
        function add_panels(obj)
            obj.panels.add(UpdatePanel(obj));
            obj.panels.add(InfoPanel(obj));
            obj.panels.add(ChannelPanel(obj));
            obj.panels.add(PlotPanel(obj));
            obj.panels.add(HistogramPanel(obj));
        end
        
        function set_sweep(obj,sweep)
            obj.sweep = mod(sweep-1,numel(obj.triggertimes))+1;
            obj.plot_channels();
        end
        
        function triggerparents = get.triggerparents(obj)
            if isempty(obj.sequence)
                triggerparents = [];
            else
                triggerparents = obj.sequence.gettriggerparents(obj.tmin,obj.tmax);
            end
        end
        
        function triggers = get.triggers(obj)
            triggers = obj.triggerparent.triggers;
        end
        
        function triggertimes = get.triggertimes(obj)
            if isempty(obj.trigger)
                triggertimes = [];
            else
                triggertimes = obj.trigger.gettimes(obj.tmin,obj.tmax);
            end
        end
        
        function sequence_listener(obj)
            obj.dbg_in(mfilename,'sequence_listener');
            if isempty(obj.sequence) || ~obj.triggerparents.n
                obj.triggerparent = [];
            elseif isempty(obj.trigger) || ~obj.triggerparents.contains(obj.trigger)
                triggerparent_str = obj.triggerparents.values('tag');
                val = find(cellfun(@(x) strcmp(x,'DigMark'),triggerparent_str),1);
                if isempty(val),    val = 1;    end
                obj.triggerparent = obj.triggerparents.get(val);
                obj.triggerparent_listener();
            end
            obj.dbg_out(mfilename,'sequence_listener');
        end
    end
    methods (Access = 'protected')
        function triggerparent_listener(obj)
            obj.dbg_in(mfilename,'triggerparent_listener\n');
            if isempty(obj.triggerparent) || ~obj.triggerparent.triggers.n
                obj.trigger = [];
            else
                obj.trigger = obj.triggerparent.triggers.get(1);
            end
            obj.dbg_out(mfilename,'triggerparent_listener\n');
        end
    end
end