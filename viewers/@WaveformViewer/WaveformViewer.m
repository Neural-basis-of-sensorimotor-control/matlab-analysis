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
            addlistener(obj,'triggerparent','PostSet',@(~,~) obj.triggerparent_listener);            
        end
        
        function add_main_panel(obj)
            obj.panels.add(UpdatePanel(obj));
            obj.panels.add(InfoPanel(obj));
        end
        
        function add_panels(obj)
            obj.add_main_panel();
            if ~isempty(obj.sequence)
                obj.panels.add(ChannelPanel(obj));
                obj.panels.add(PlotPanel(obj));
                obj.panels.add(HistogramPanel(obj));
            end
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
            if isempty(obj.sequence) || ~obj.triggerparents.n
                obj.triggerparent = [];
            elseif isempty(obj.trigger) || ~obj.triggerparents.contains(obj.trigger)
                triggerparent_str = obj.triggerparents.values('tag');
                val = find(cellfun(@(x) strcmp(x,'DigMark'),triggerparent_str),1);
                if isempty(val),    val = 1;    end
                obj.triggerparent = obj.triggerparents.get(val);
                obj.triggerparent_listener();
            end
        end
    end
    methods (Access = 'protected')
        function triggerparent_listener(obj)
            if isempty(obj.triggerparent) || ~obj.triggerparent.triggers.n
                obj.trigger = [];
            else
                obj.trigger = obj.triggerparent.triggers.get(1);
            end
        end
    end
end