classdef ScFile < ScList
    %One for each spike2 / adq file
    %children: ScSequence
    properties
        parent      %ScExperiment
        filename    %name of .mat / .adq file
        comment
        spikefiles  %extra files with spike data imported from Spike2
        
        signals         %List of analog channels (ScSignal)
        stims           %List of digital channels (ScStim / ScAdqTriggerParent)
        textchannels    %TextMark / Keyboard channel in Spike2 (ScTextMark)
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
        
        function filepath = get.filepath(obj)
            filepath = fullfile(obj.parent.fdir,obj.filename);
        end
        
        %Parse experimental protocol (.txt)
        function update_from_protocol(obj, protocolfile)
            obj.parse_protocol(protocolfile);
        end
        
        %todo: change access to private
        function parse_protocol(obj, protocolfile)
            fid = fopen(protocolfile);
            while 1
                line = fgetl(fid);
                if isnumeric(line) && line == -1
                    fclose(fid);
                    msgbox(['Could not find file ''' obj.tag '''in protocol file'])
                    return
                elseif strcmp(line, ['¤¤' obj.tag])
                    break;
                end
            end
            sequence = [];
            while 1
                line = fgetl(fid);
                if checkForEof(line)
                    if ~isempty(sequence)
                        if ~obj.has('tag',sequence.tag)
                            obj.add(sequence);
                        end
                        obj.sc_loadsignals();
                        if sequence.signals.n
                            N = cell2mat({sequence.signals.list.N});
                            dt = cell2mat({sequence.signals.list.dt});
                            sequence.tmax = max((N+1).*dt);
                        else
                            sequence.tmax = inf;
                        end
                    end
                    fclose(fid);
                    return;
                elseif checkForCell(line)
                    if isempty(obj.comment)
                        obj.comment = line(3:end);
                    else
                        obj.comment = sprintf([obj.comment '\n' line]);
                    end
                elseif checkForEvent(line)
                    pos = find(line==' ',2);
                    tmin = str2double(line(pos(1):pos(2)));
                    tag = line(1);
                    %Set tmax for previous sequence
                    if ~isempty(sequence)
                        sequence.tmax = tmin;
                    end
                    if obj.has('tag',tag)
                        sequence = obj.get('tag',tag);
                    else
                        sequence = ScSequence(obj,tag,tmin);
                        obj.add(sequence);
                    end
                    sequence.comment = line(pos(2)+1:end-3);
                elseif ~isempty(line) && ~isempty(sequence)
                    if isempty(sequence.comment)
                        sequence.comment = line;
                    else
                        sequence.comment = sprintf([sequence.comment '\n' line]);
                    end
                end
            end
        end
        
        %Load all spiketimes + digital channels, but not analog channels
        function success = sc_loadtimes(obj)
            success = obj.check_fdir;
            if ~success, return;    end
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
        function success = check_fdir(obj)
            success = false;
            if exist(obj.filepath, 'file') == 2
                success = true;
            else
                while  exist(obj.filepath, 'file') ~= 2
                    answer = questdlg(['File ' obj.filename ' could not be ' ...
                        'found in current directory. Abort program?'],'',...
                        'Yes, abort','No, choose new directory',...
                        'No, choose new directory');
                    switch answer
                        case 'Yes, abort'
                            return
                        case 'No, choose new directory'
                        otherwise
                            error(['debugging error: ' answer ' could not be found'])
                    end
                    dname = uigetdir(obj.parent.fdir,'Choose load directory');
                    if ~isnumeric(dname)
                        obj.parent.fdir = dname;
                        obj.sc_save(false);
                        success = true;
                    end
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
        function triggers = gettriggers(obj,tmin,tmax)
            triggers = ScCellList;
            for i=1:obj.signals.n
                trgs = obj.signals.get(i).triggers;
                for j=1:trgs.n
                    trg = trgs.get(j);
                    if numel(trg.gettimes(tmin,tmax))
                        triggers.add(trg);
                    end
                end
            end
            for i=1:obj.textchannels.n
                textchannel = obj.textchannels.get(i);
                for j=1:textchannel.triggers.n
                    trigger = textchannel.triggers.get(j);
                    if numel(trigger.gettimes(tmin,tmax))
                        triggers.add(trigger);
                    end
                end
            end
            for i=1:obj.stims.n
                stim = obj.stims.get(i);
                if stim.istrigger && numel(stim.gettimes(tmin,tmax))
                    triggers.add(stim);
                else
                    stimtriggers = stim.triggers;
                    for j=1:stimtriggers.n
                        if numel(stimtriggers.get(j).gettimes(tmin,tmax))
                            triggers.add(stimtriggers.get(j));
                        end
                    end
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
        
        function saved = sc_save(obj,varargin)
            saved = obj.parent.sc_save(varargin{:});
        end
        
        %File is either adq file or spike2 file
        function is_adq_file = get.is_adq_file(obj)
            [~,~,ext] = fileparts(obj.filename);
            is_adq_file = strcmpi(ext,'.adq');
        end
    end
    
    methods (Access = private)
        function success = init_spike2_file(obj)
            success = false;
            channelnames = who('-file',obj.filepath);
            for i=1:numel(channelnames)
                channelname = channelnames{i};
                d = load(obj.filepath,channelname);
                channelstruct = d.(channelname);
                if isfield(channelstruct,'values')
                    signal = ScSignal(obj,channelname,'tag',channelname);
                    signal.dt = channelstruct.interval;
                    signal.N = channelstruct.length;
                    obj.signals.add(signal);
                    if isempty(strfind(channelname,'patch'))
                        signal.filter.smoothing_width = 1;
                        signal.filter.artifact_width = 0;
                    end
                elseif strcmpi(channelname,'TextMark') || ...
                        strcmpi(channelname,'Keyboard')
                    textchannel = ScTextMark(obj,channelname,'tag',channelname);
                    obj.textchannels.add(textchannel);
                elseif isfield(channelstruct,'times')
                    obj.stims.add(ScStim(obj,channelname,'tag',channelname));
                end
            end
            for i=1:obj.stims.n
                obj.stims.get(i).sc_loadtimes;
            end
            for i=1:obj.signals.n
                obj.signals.get(i).filter.update_stims();
            end
            for i=1:obj.stims.n
                obj.stims.get(i).sc_clear;
            end
            for j=1:numel(obj.spikefiles)
                spikefile = obj.spikefiles{j};
                d = load(fullfile(obj.fdir,spikefile));
                [~,name] = fileparts(obj.filepath);
                tag_ = regexp(spikefile,['^' name '_(\w*).mat.{0,0}'],'tokens');
                spike = ScWaveform(obj,cell2mat(tag_{1}),spikefile);
                if ~isfield(d,spike)
                    return;
                end
                switch d.spikes.comment
                    case 'patch'
                        obj.signals.get('tag','patch').waveforms.add(spike);
                    case 'patch1'
                        obj.signals.get('tag','patch').waveforms.add(spike);
                    case 'patch2'
                        obj.signals.get('tag','patch2').waveforms.add(spike);
                    otherwise
                        obj.signals.get('tag','patch').waveforms.add(spike);
                end
            end
            success = true;
        end
        
        function success = init_adq_file(obj)
            success = false;
            [fid, errmsg] = fopen(obj.filepath);%,'r');%,'b');%,'UTF-8');
            if fid==-1
                fprintf('Error reading adq file: %s\n',errmsg);
                return
            end
            buffersize = fread(fid,1,'uint16')/2;
            dt = fread(fid,1,'uint16')*1e-6;
            fread(fid,1,'uint16');      %pretrigger (not used)
            nbrofchannels = fread(fid,1,'uint8');
            should_be_one = fread(fid,1,'uint8');
            if should_be_one~=1,    warning('check value that should be one equals %i\n',should_be_one); end
            nbrofsweeps = fread(fid,1,'uint32');
            N = nbrofsweeps*buffersize;
            all_zeros = fread(fid,244,'uint8');
            if nnz(all_zeros), warning('%i values that should equal zero differ from zero\n',nnz(all_zeros)); end
            fclose(fid);
            
            for k=1:nbrofchannels
                tag = sprintf('ch%i',k);
                signal = ScSignal(obj,256+(k-1)*N,'tag',tag,...
                    'dt',dt,'N',N);
                signal.filter.smoothing_width = 1;
                signal.filter.artifact_width = 0;
                obj.signals.add(signal);
            end
            triggerparent = ScAdqTriggerParent();
            triggerparent.triggers.add(ScAdqSweeps(nbrofsweeps, buffersize*dt));  
            obj.stims.add(triggerparent);
            success = true;
        end
    end
end

%Return true if end of protocol file is reached
function [stopParsing] = checkForEof(line)
stopParsing = ~isempty(line) && ((isnumeric(line) && line == -1) || (length(line) > 2 && strcmp(line(1:2),'¤¤')));
end

%Return true if line contains a new event
function [newEvent] = checkForEvent(line)
newEvent = length(line) > 2 && strcmpi(line(end-1:end),'##');
end

%return true if line contains a new neuron
function [newCell] = checkForCell(line)
newCell = length(line) > 2 && strcmpi(line(1:2),'%%');
end
