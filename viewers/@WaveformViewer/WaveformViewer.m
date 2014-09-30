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
            addlistener(obj,'main_signal','PostSet',@main_signal_listener);
            addlistener(obj,'sequence','PostSet',@sequence_listener); 
            
            function main_signal_listener(~,~)
                if ~isempty(obj.main_signal) && obj.main_signal.waveforms.n
                    obj.waveform = obj.main_signal.waveforms.get(1);
                else
                    obj.waveform = [];
                end
            end
            
            function sequence_listener(~,~)
                obj.dbg_in(mfilename,'sequence_listener');
                if isempty(obj.sequence) || ~obj.triggerparents.n
                    obj.triggerparent = [];
                else
                    obj.triggerparent = obj.triggerparents.get(1);
                    addlistener(obj,'triggerparent','PostSet',@triggerparent_listener);
                end
                obj.dbg_out(mfilename,'sequence_listener');
            end
            
            function triggerparent_listener(~,~)
                obj.dbg_in(mfilename,'triggerparent_listener\n');
                if isempty(obj.triggerparent) || ~obj.triggerparent.triggers.n
                    obj.trigger = [];
                else
                    obj.trigger = obj.triggerparent.triggers.get(1);
                end
                obj.dbg_out(mfilename,'triggerparent_listener\n');
            end
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
    end
end