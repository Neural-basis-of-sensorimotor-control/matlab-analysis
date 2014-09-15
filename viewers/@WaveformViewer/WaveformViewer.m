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
            addlistener(obj,'main_signal','PostSet',@main_signal_listener);
            
            function main_signal_listener(~,~)
                if ~isempty(obj.main_signal) && obj.main_signal.waveforms.n
                    obj.waveform = obj.main_signal.waveforms.get(1);
                else
                    obj.waveform = [];
                end
            end
            %obj.main_channel = AnalogAxes(obj);
        end
        
        function add_panels(obj)
            obj.panels.add(InfoPanel(obj));
            obj.panels.add(ChannelPanel(obj));
        end
        
        function set_sweep(obj,sweep)
            obj.sweep = mod(sweep-1,numel(obj.triggertimes))+1;
            obj.plot_channels();
        end
        
        function triggerparents = get.triggerparents(obj)
            triggerparents = obj.sequence.gettriggerparents(obj.tmin, obj.tmax);
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
    end
end