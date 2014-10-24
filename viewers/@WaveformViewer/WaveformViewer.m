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
        
        function add_constant_panels(obj)
            obj.panels.add(UpdatePanel(obj));
            obj.panels.add(InfoPanel(obj));
        end
        
        function add_dynamic_panels(obj)    
            obj.panels.add(ChannelPanel(obj));
            obj.panels.add(PlotPanel(obj));
            obj.panels.add(HistogramPanel(obj));
        end
        
        function delete_dynamic_panels(obj)
            for k=obj.panels.n:-1:3
                panel = obj.panels.get(k);
                obj.panels.remove(panel);
                delete(panel);
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
            elseif isempty(obj.triggerparent)
                obj.triggerparent = obj.triggerparents.get(1);
            elseif obj.triggerparents.contains(obj.triggerparent)
                obj.triggerparent = obj.triggerparent;
            else
                tag = obj.triggerparent.tag;
                if sc_contains(obj.triggerparents.values('tag'),tag)
                    obj.triggerparent = obj.triggerparents.get('tag',tag);
                else
                    obj.triggerparent = obj.triggerparents.get(1);
                end
            end
        end
    end
    methods (Access = 'protected')
        function triggerparent_listener(obj)
            if isempty(obj.triggerparent) || ~obj.triggerparent.triggers.n
                obj.trigger = [];
            else
                triggers = obj.triggerparent.triggers;
                if isempty(obj.trigger)
                    obj.trigger = triggers.get(1);
                elseif triggers.contains(obj.trigger)
                    obj.trigger = obj.trigger;
                else
                    tag = obj.trigger.tag;
                    if sc_contains(triggers.values('tag'),tag)
                        obj.trigger = triggers.get('tag',tag);
                    else
                        obj.trigger = triggers.get(1);
                    end
                end
            end
        end
    end
end