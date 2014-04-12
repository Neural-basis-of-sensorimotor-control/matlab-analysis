classdef ScGuiManager < handle
    
    %maybe explicit setters and getters should be added to these for consistency
    properties (SetObservable = true)
        waveform
        text
        
        xmin
        xmax
    end
    
    %properties with explicit setter and getters
    properties (SetObservable = true, GetAccess = 'private', SetAccess = 'private')
        state_ = ScGuiState.spike_detection;
        signal_
        no_trigger_ = false
        triggerparent_
        trigger_
        ampl_
        
        experiment_
        file_
        sequence_
        
        sweep_
        mouse_press_
        
        pretrigger_ = -.1
        posttrigger_ = .1
        
        zoom_on_ = false
        pan_on_ = false
        
    end
    
    %setters and getters
    properties (Dependent)
        state
        signal
        
        ampl
        no_trigger
        triggerparent
        trigger
        
        experiment
        file
        sequence
        
        sweep
        mouse_press
        
        pretrigger
        posttrigger
        
        zoom_on
        pan_on
    end
    
    methods
        
        function val = get.experiment(obj)
            val = obj.experiment_;
        end
        
        function set.experiment(obj,val)
            if isempty(obj.experiment) && isempty(val)
                obj.file = [];
            elseif isempty(val) || val.n == 0
                obj.file = [];
            elseif isempty(obj.experiment) || obj.experiment.n == 0
                obj.file = val.get(1);
            elseif obj.experiment == val
                obj.file = obj.file;
            else
                obj.file = val.get(1);
            end
            if ~isempty(obj.experiment)
                %todo: check for unsaved changes
                obj.experiment.sc_clear();
            end
            obj.experiment_ = val;
        end
        
        function val = get.file(obj)
            val = obj.file_;
        end
        
        function set.file(obj,val)
            if isempty(val) || ~val.n
                obj.sequence = [];
            elseif isempty(obj.file) || ~obj.file.n
                obj.sequence = val.get(1);
            elseif obj.file == val && val.contains(obj.sequence)
                obj.sequence = obj.sequence;
            else
                obj.sequence = val.get(1);
            end
            if ~isempty(obj.file)
                obj.file.sc_clear;
            end
            if ~isempty(val)
                val.sc_loadtimes();
            end
            obj.file_ = val;
        end
        
        function val = get.sequence(obj)
            val = obj.sequence_;
        end
        
        function set.sequence(obj, val)
            %Set ampl
            if isempty(val) || ~val.ampl_list.n
                obj.ampl = [];
            elseif isempty(obj.sequence) || ~obj.sequence.ampl_list.n
                obj.ampl = val.ampl_list.get(val.ampl_list.n);
            elseif val == obj.sequence && val.ampl_list.contains(obj.ampl)
                obj.ampl = obj.ampl;
            else
                obj.ampl = val.ampl_list.get(val.ampl_list.n);
            end
            %Set signal
            if isempty(val) || ~val.signals.n
                obj.signal = [];
            elseif isempty(obj.sequence) || ~obj.sequence.signals.n
                patchnbr = find(cellfun(@(x) strcmpi(x,'patch') || strcmpi(x,'patch1'), ...
                    val.signals.values('tag')),1);
                if isempty(patchnbr)
                    patchnbr = 1;
                end
                obj.signal = val.signals.get(patchnbr);
            elseif obj.sequence == val && val.signals.contains(obj.signal)
                obj.signal = obj.signal;
            else
                patchnbr = find(cellfun(@(x) strcmpi(x,'patch') || strcmpi(x,'patch1'), ...
                    val.signals.values('tag')),1);
                if isempty(patchnbr)
                    patchnbr = 1;
                end
                obj.signal = val.signals.get(patchnbr);
            end
            %Set trigger
            if isempty(val) || ~val.gettriggerparents(val.tmin,val.tmax).n
                obj.triggerparent = [];
            else
                obj.triggerparent = val.gettriggerparents(val.tmin,val.tmax).get(1);
            end
            obj.sequence_ = val;
        end
        
        function val = get.state(obj)
            val = obj.state_;
        end
        
        function set.state(obj,val)
            obj.state_ = val;
            if obj.state == ScGuiState.ampl_analysis && numel(obj.triggertimes)
                obj.mouse_press = 1;
            end
        end
        
        function signal = get.signal(obj)
            if isempty(obj.ampl)
                signal = obj.signal_;
            else
                signal = obj.ampl.parent_signal;
            end
        end
        
        function set.signal(obj, val)
            %Update waveform
            if isempty(val) || ~val.waveforms.n
                obj.waveform = [];
            elseif isempty(obj.signal) || ~obj.signal.waveforms.n
                obj.waveform = val.waveforms.get(val.waveforms.n);
            elseif obj.signal == val && val.waveforms.contains(obj.waveform)
                obj.waveform = obj.waveform;
            else
                obj.waveform = val.waveforms.get(val.waveforms.n);
            end
            obj.signal_ = val;
            if obj.state == ScGuiState.ampl_analysis
                %Call ampl listeners
                obj.ampl = obj.ampl;
            end
        end
        
        function val = get.ampl(obj)
            if obj.state == ScGuiState.ampl_analysis
                val = obj.ampl_;
            else
                val = [];
            end
        end
        
        function set.ampl(obj, val)
            obj.ampl_ = val;
        end
        
        function val = get.triggerparent(obj)
            if obj.state == ScGuiState.ampl_analysis
                val = [];
            else
                val = obj.triggerparent_;
            end
        end
        
        function set.triggerparent(obj,val)
            if isempty(val) || ~val.triggers.n
                obj.trigger = [];
            else
                obj.trigger = val.triggers.get(1);
            end
            obj.triggerparent_ = val;
        end
        
        function val = get.no_trigger(obj)
            if obj.state == ScGuiState.ampl_analysis
                val = false;
            else
                val = obj.no_trigger_;
            end
        end
        
        function set.no_trigger(obj,val)
            obj.no_trigger_ = val;
            if ~val
                obj.triggerparent = obj.triggerparent;
            end
        end
        
        function val = get.trigger(obj)
            if obj.state == ScGuiState.ampl_analysis
                val = obj.ampl;
            else
                val = obj.trigger_;
            end
        end
        
        function set.trigger(obj, val)
            obj.trigger_ = val;
            if obj.state == ScGuiState.ampl_analysis && numel(obj.triggertimes)
                obj.mouse_press = 1;
            end
        end
        
        function val = get.sweep(obj)
            val = obj.sweep_;
        end
        
        function set.sweep(obj,val)
            obj.zoom_on = false; obj.pan_on = false;
            if size(val,1)>1,    val = val';   end
            obj.sweep_ = mod(val-1,numel(obj.triggertimes))+1;
            if obj.state == ScGuiState.ampl_analysis && ~isempty(obj.ampl) && numel(obj.triggertimes)
                triggertime = obj.triggertimes(obj.sweep(1));
                val = obj.ampl.get_data(triggertime,[1 3]);
                mousepress = find(isnan(val),1);
                if isempty(mousepress)
                    obj.mouse_press = 0;
                else
                    obj.mouse_press = mousepress;
                end
            end
        end
        
        function val = get.mouse_press(obj)
            val = obj.mouse_press_;
        end
        
        function set.mouse_press(obj,val)
            obj.mouse_press_ = val;
            if obj.mouse_press ==1 || obj.mouse_press == 2
                obj.text = sprintf('Awaiting mouse press #%i',obj.mouse_press);
            else
                obj.text = 'Amplitude is set for this sweep';
            end
        end
        
        function val = get.pretrigger(obj)
            if obj.xmin < obj.pretrigger_
                val = obj.xmin;
            else
                val = obj.pretrigger_;
            end
        end
        
        function set.pretrigger(obj,val)
            obj.pretrigger_ = val;
            obj.xmin = val;
        end
        
        function val = get.posttrigger(obj)
            if obj.xmax > obj.posttrigger_
                val = obj.xmax;
            else
                val = obj.posttrigger_;
            end
        end
        
        function set.posttrigger(obj,val)
            obj.posttrigger_ = val;
            obj.xmax = val;
        end
        
        function val = get.zoom_on(obj)
            val = obj.zoom_on_;
        end
        
        function set.zoom_on(obj,val)
            if obj.pan_on && val
                obj.pan_on = false;
            end
            obj.zoom_on_ = val;
        end
        
        function val = get.pan_on(obj)
            val = obj.pan_on_;
        end
        
        function set.pan_on(obj,val)
            if obj.zoom_on && val
                obj.zoom_on = false;
            end
            obj.pan_on_ = val;
        end
    end
    
    properties
        has_unsaved_changes = false
        
        %GUI components
        %to do - replace hardcoded panels (e.g. filepanel etc) with dynamic
        %list
        current_view
        filepanel
        triggerpanel
        plotpanel
        waveformpanel
        histogrampanel
        savepanel
        
        %Axes
        %to do - replace hardcoded axes (e.g. filepanel etc) with dynamic
        %list
        stimaxes
        signalaxes
        extrasignalaxes
        histogramaxes
        
        %Plot constants
        leftpanelwidth = 300
        borderwidth = 50
        plotheight = 200
        
        %Plot variables that require reloading of plot panel
        plot_waveform_shapes = false
        wfpos
        v
        v_raw
        plot_raw = false
        
        %Plot variables that can be applied on the fly
        t_offset        
        
        hist_pretrigger = -.1
        hist_posttrigger = .1
        hist_binwidth = 1e-2
        
        %Misc constants
        max_array_size = 1e9
        show_triggers
        
        %Function handles
        %todo: as far as possible, replace with callbacks from GUI
        %components and listeners that listen to ScGuiManager properties
        load_sequence_fcn
        update_plotpanel_fcn
        update_histogrampanel_fcn
        update_savepanel_fcn
        
        %Plot function handles
        %variable function that is called whenever the plot is updated
        plot_fcn
        %Plot spikes and triggers
        plot_stims_fcn
        %Plot waveform shapes on top of existing signal
        plot_waveform_shapes_fcn
        %normal plot
        default_plot_fcn
        %remove thresholds by clicking in figure
        remove_threshold_fcn
    end
    
    properties (Dependent)
        triggertimes
        tmin
        tmax
        t_full
    end
    
    methods
        function obj = ScGuiManager(experiment)
            obj.experiment = experiment;
            obj.extrasignalaxes = ScList;
            %the sequence listener keep track of which digital channels
            %that should be displayed. this solution is very much ad hoc,
            %and should probably be replaced by a dependent function
            addlistener(obj,'sequence_','PostSet',@sequence_listener);
            
            function sequence_listener(~,~)
                if ~isempty(obj.sequence)
                    triggers = obj.sequence.gettriggers(obj.tmin,obj.tmax);
                    if triggers.n>numel(obj.show_triggers)
                        obj.show_triggers(numel(obj.show_triggers)+1:triggers.n,1) = ...
                            true(triggers.n-numel(obj.show_triggers),1);
                    else
                        obj.show_triggers = true(triggers.n,1);
                    end
                else
                    obj.show_triggers = [];
                end
            end
            
        end
        
        function show(obj)
            obj.current_view = gcf;
            clf(obj.current_view,'reset');
            show_experiment(obj);
        end

        %The GUI requires trigger times to plot the data around
        function triggertimes = get.triggertimes(obj)
            if isempty(obj.trigger) || isempty(obj.signal)
                triggertimes = [];
            else
                triggertimes = obj.trigger.gettimes(obj.tmin,obj.tmax);
                triggertimes = triggertimes(triggertimes>obj.tmin-obj.pretrigger & ...
                    triggertimes<obj.tmax-obj.posttrigger);
            end
        end
        
        function clear_axes(obj)
            cla(obj.stimaxes,'reset');
            cla(obj.signalaxes,'reset');
            for i=1:obj.extrasignalaxes.n
                cla(obj.extrasignalaxes.get(i).axeshandle,'reset');
            end
            cla(obj.histogramaxes,'reset');
        end
        
        function tmin = get.tmin(obj)
            if isempty(obj.sequence)
                tmin = [];
            else
                tmin = obj.sequence.tmin;
            end
        end
        
        function tmax = get.tmax(obj)
            if isempty(obj.sequence)
                tmax = [];
            else
                tmax = obj.sequence.tmax;
            end
        end
        
        %Freezes the panel to stop the user from calling more than one
        %callback at the time. Only used for time-consuming callbacks
        function disable_all(obj,disable_on)
            global DEBUG
            if disable_on
                obj.text = 'Computing, if program freezes write ''close'' command in command prompt to shut down';
            else
                obj.text = '';
            end
            if ~DEBUG
                enableDisableFig(obj.current_view, ~disable_on);
            end    
        end
        
    end
end