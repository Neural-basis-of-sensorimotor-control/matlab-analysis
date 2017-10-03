classdef ScFile < ScList & ScDynamicClass
  
  methods (Access = private)
    
    varargout = init_spike2_file(varargin)
    varargout = init_adq_file(varargin)
    varargout = parse_protocol(varargin)
    
  end
  
  % One for each spike2 / adq file
  % Children: ScSequence
  
  properties
    
    parent            % ScExperiment
    filename          % name of .mat / .adq file
    depth_mm          % subcortical depth
    comment
    spikefiles        % extra files with spike data imported from Spike2
    
    signals           % List of analog channels (ScSignal)
    stims             % List of digital channels (ScStim / ScAdqTriggerParent)
    textchannels      % TextMark / Keyboard channel in Spike2 (ScTextMark)
    discrete_signals  % ScList of any type of triggers
    
    user_comment
    
  end
  
  properties (Dependent)
    
    is_adq_file
    tag
    filepath
    fdir
    channels
    
  end
  
  methods
    
    %ScFile
    %   filename    ends either with .mat or .adq
    function obj = ScFile(parent, filename)
      
      obj.parent = parent;
      obj.filename = filename;
      obj.signals = ScList();
      obj.stims = ScList();
      obj.textchannels = ScList();
      
    end
    
    
    function tag = get.tag(obj)
      [~,tag] = fileparts(obj.filename);
    end
    
    
    function set.filepath(obj, val)
      
      [pname, fname, ext] = fileparts(val);
      obj.parent.set_fdir(pname);
      obj.filename = [fname ext];
      
    end
    
    
    function val = get.filepath(obj)
      val = fullfile(obj.parent.fdir, obj.filename);
    end
    
    
    %Parse experimental protocol (.txt)
    function update_from_protocol(obj, protocolfile)
      obj.parse_protocol(protocolfile);
    end
    
    
    %Load all spiketimes + digital channels, but not analog channels
    function sc_loadtimes(obj)
      
      obj.check_raw_data_dir();
      
      for i=1:obj.stims.n
        obj.stims.get(i).sc_loadtimes();
      end
      
      for i=1:obj.textchannels.n
        obj.textchannels.get(i).sc_loadtimes();
      end
      
      for i=1:obj.signals.n
        obj.signals.get(i).sc_loadtimes;
      end
      
    end
    
    
    %Load analog signals
    function sc_loadsignals(obj)
      
      obj.check_raw_data_dir();
      
      for i=1:obj.signals.n
        obj.signals.get(i).sc_loadsignal();
      end
      
    end
    
    
    %Clear transient data
    function sc_clearsignals(obj)
      
      for i=1:obj.signals.n
        obj.signals.get(i).sc_clear();
      end
      
    end
    
    
    %Clear all data
    function sc_clear(obj)
      
      for i=1:obj.channels.n
        obj.channels.get(i).sc_clear();
      end
      
    end
    
    
    %Check that raw data file exists on hard drive
    function success = prompt_for_raw_data_dir(obj)
      
      success = true;
      
      while ~exist(obj.filepath, 'file')
        answer = questdlg(['File ' obj.filename ' could not be ' ...
          'found in current directory. Abort program?'],'',...
          'Yes, abort', 'No, choose new directory',...
          'No, choose new directory');
        
        if strcmp(answer, 'Yes, abort')
          
          success = false;
          return
          
        end
        
        dname = uigetdir(obj.parent.fdir, ...
          ['Choose load directory for ' obj.tag]);
        
        if ~isnumeric(dname)
          obj.parent.set_fdir(dname);
        end
        
      end
      
    end
    
    
    % Initialize object by populating signals, stims and textchannels
    % To be done right after object creation, normally only once during
    % objects lifetime
    function success = init(obj,force_init)
      
      %check if sequence has been initialized before
      if nargin<2 || ~force_init
        
        if obj.signals.n || obj.stims.n || obj.textchannels.n
          
          success = false;
          return;
          
        end
        
      end
      
      if obj.is_adq_file
        success = obj.init_adq_file();
      else
        success = obj.init_spike2_file();
      end
      
    end
    
    %Triggers = objects that can be triggered on
    %Implement function gettimes, and property istrigger returns true
    %Only returns objects where numel(times)>0
    function triggers = gettriggers(obj, tmin, tmax)
      
      if nargin == 1
        triggers = obj.get_waveforms();
      else
        triggers = ScCellList(obj.get_waveforms(tmin, tmax));
      end
      
      for i=1:obj.textchannels.n
        
        textchannel = obj.textchannels.get(i);
        
        for j=1:textchannel.triggers.n
          
          trigger = textchannel.triggers.get(j);
          
          if nargin == 1 || ~isempty(trigger.gettimes(tmin,tmax))
            triggers.add(trigger);
          end
          
        end
        
      end
      
      for i=1:obj.stims.n
        
        stim = obj.stims.get(i);
        
        if stim.istrigger && ... 
            (nargin == 1 || ~isempty(stim.gettimes(tmin,tmax)))
          
          triggers.add(stim);
          
        else
          
          stimtriggers = stim.triggers;
          
          for j=1:stimtriggers.n
            
            if nargin == 1 || ~isempty(stimtriggers.get(j).gettimes(tmin,tmax))
              triggers.add(stimtriggers.get(j));
            end
            
          end
          
        end
        
      end
      
      if isempty(obj.discrete_signals)
        
        for i=1:obj.discrete_signals.n
          triggers.add(obj.discrete_signals.get(i));
        end
        
      end
      
    end
    
    
    %channels = all channels from raw data file
    function channels = get.channels(obj)
      
      channels = ScCellList();
      
      for i=1:obj.signals.n
        channels.add(obj.signals.get(i));
      end
      
      for i=1:obj.stims.n
        channels.add(obj.stims.get(i));
      end
      
      for i=1:obj.textchannels.n
        channels.add(obj.textchannels.get(i));
      end
      
    end
    
    %Triggerparent = a channel with child object that can be triggered
    %on
    %implements istrigger (return false), and triggers (return all
    %children that are triggers)
    function triggerparents = gettriggerparents(obj,tmin,tmax)
      
      triggerparents = ScCellList();
      
      for i=1:obj.signals.n
        
        channel = obj.signals.get(i);
        trgs = channel.triggers;
        
        for j=1:trgs.n
          
          if numel(trgs.get(j).gettimes(tmin,tmax))
            
            triggerparents.add(channel);
            break;
            
          end
          
        end
        
      end
      
      for i=1:obj.stims.n
        
        stimtriggers = obj.stims.get(i).triggers;
        
        for j=1:stimtriggers.n
          
          if numel(stimtriggers.get(j).gettimes(tmin,tmax))
            
            triggerparents.add(obj.stims.get(i));
            break;
            
          end
          
        end
        
      end
      
      for i=1:obj.textchannels.n
        
        textchannel = obj.textchannels.get(i);
        
        for j=1:textchannel.triggers.n
          
          if numel(textchannel.triggers.get(j).gettimes(tmin,tmax))
            
            triggerparents.add(textchannel);
            break;
            
          end
          
        end
        
      end
      
    end
    
    
    function fdir = get.fdir(obj)
      fdir = obj.parent.fdir;
    end
    
    
    function saved = sc_save(obj, prompt_before_saving)
      
      if ischar(prompt_before_saving)
        
        save_path            = prompt_before_saving;
        prompt_before_saving = false;
        
      else
        
        save_path            = obj.parent.save_name;
        
      end
      
      saved                = save_experiment(obj.parent, save_path, prompt_before_saving);
      
    end
    
    
    %File is either adq file or spike2 file
    function is_adq_file = get.is_adq_file(obj)
      
      [~,~,ext] = fileparts(obj.filename);
      is_adq_file = strcmpi(ext,'.adq');
      
    end
    
    
    function add_spike2_channels(obj)
      
      channelnames = who('-file',obj.filepath);
      
      for i=1:numel(channelnames)
        channelname = channelnames{i};
        d = load(obj.filepath,channelname);
        channelstruct = d.(channelname);
        
        if isfield(channelstruct,'values')
          
          if ~obj.signals.has('tag',channelname)
            signal = ScSignal(obj,channelname,'tag',channelname);
            signal.dt = channelstruct.interval;
            signal.N = channelstruct.length; %<- sometimes incorrect value from Spike2
            obj.signals.add(signal);
            
            if isempty(strfind(channelname,'patch'))
              signal.filter.smoothing_width = 1;
              signal.filter.artifact_width = 0;
            end
            
          end
          
        elseif strcmpi(channelname,'TextMark') || ...
            strcmpi(channelname,'Keyboard')
          
          if ~obj.textchannels.has('tag',channelname)
            
            textchannel = ScTextMark(obj,channelname,'tag',channelname);
            obj.textchannels.add(textchannel);
            
          end
          
        elseif isfield(channelstruct,'times')
          
          if ~obj.stims.has('tag',channelname)
            obj.stims.add(ScStim(obj,channelname,'tag',channelname));
          end
          
        else
          
          msg = sprintf('Warning: Channel %s in file %s did not meet any criteria in %s.\n Go find Hannes if you think this channel should be viewable.', channelname, obj.tag, mfilename);
          msgbox(msg);
          fprintf('%s\n', msg);
          
        end
        
      end
      
    end
    
  end
  
end

