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
        nbr_of_constant_panels
    end
    
    methods (Static)
        function enum = mode
            enum = ScGuiState.spike_detection;
        end
    end
    
    methods
        function obj = WaveformViewer(guimanager,varargin)
            obj@SequenceViewer(guimanager,varargin{:});
            obj.create_channels();
            obj.wf_setup_listeners();
            addlistener(obj,'sequence','PostSet',@(~,~) obj.sequence_listener());
            addlistener(obj,'triggerparent','PostSet',@(~,~) obj.triggerparent_listener);            
        end
        
        function add_constant_panels(obj)
            obj.panels.add(InfoPanel(obj));
        end
        
        function add_dynamic_panels(obj)    
            obj.panels.add(WfChannelPanel(obj));
            obj.panels.add(WfPlotPanel(obj));
            obj.panels.add(HistogramPanel(obj));
        end
        
        function delete_dynamic_panels(obj)
            %todo - replace hardcoded number with function
            for k=obj.panels.n:-1:obj.nbr_of_constant_panels+1
                panel = obj.panels.get(k);
                obj.panels.remove(panel);
                delete(panel);
            end
        end
        
        function triggerparents = get.triggerparents(obj)
            if isempty(obj.sequence)
                triggerparents = [];
            else
                triggerparents = obj.sequence.gettriggerparents(obj.tmin,obj.tmax);
            end
        end
        
        function triggers = get.triggers(obj)
            if isempty(obj.triggerparent)
                triggers = [];
            else
                triggers = obj.triggerparent.triggers;
            end
        end
        
        function triggertimes = get.triggertimes(obj)
            if isempty(obj.trigger)
                triggertimes = [];
            else
                triggertimes = obj.trigger.gettimes(obj.tmin,obj.tmax);
            end
        end
        
        function ret = get.nbr_of_constant_panels(~)
            ret = 3;
        end
    
    end
    methods (Access = 'protected')
        function sequence_listener(obj)
            if isempty(obj.sequence) || ~obj.triggerparents.n
                obj.triggerparent = [];
            elseif isempty(obj.triggerparent)
                str = obj.triggerparents.values('tag');
                if sc_contains(str,'DigMark')
                    obj.triggerparent = obj.triggerparents.get('tag','DigMark');
                else
                    obj.triggerparent = obj.triggerparents.get(1);
                end    
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
        function trigger_listener(obj)
            obj.sweep = obj.sweep(obj.sweep<=numel(obj.triggertimes));
            if isempty(obj.sweep) && numel(obj.triggertimes)
                obj.sweep = 1;
            end
        end
    end
end