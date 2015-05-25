function plot_eeg(obj,pretrigger,posttrigger,binwidth,plottype,bandwidth,eeg_classification)%,varargin)
%close all
clf('reset')
eeg_classification_on = false;
if plottype && nargin<6
    fprintf('No bandwidth given, bandwidth will be set to binwidth\n');
    bandwidth = binwidth;
end
if nargin>=7
    eeg_classification_on = true;
end
if ~eeg_classification_on
    eeg_classification=nan;
end

eegtag = 'EEG_classification';
d = load(obj.exp_path);
experiment = d.obj;
clear d;
for k=1:experiment.n
    file = experiment.get(k);
    file.sc_loadtimes();
    channels = file.signals;
    if channels.has('tag',eegtag)
        plot_eeg2(file,'patch',eegtag,obj,pretrigger,posttrigger,plottype,eeg_classification_on,eeg_classification);
        plot_eeg2(file,'patch2',eegtag,obj,pretrigger,posttrigger,plottype,eeg_classification_on,eeg_classification);
    else
        fprintf('File ''%s'' does not contain EEG channel ''%s''\n',file.tag,eegtag);
    end
    file.sc_clear();
end

    function plot_eeg2(file,patchtag,eegtag,obj,pretrigger,posttrigger,plottype,eeg_classification_on,eeg_classification)
        signals = file.signals;
        if signals.has('tag',patchtag)
            signal = signals.get('tag',patchtag);
            for i=1:signal.waveforms.n
                plot_eeg3(file,signal.waveforms.get(i),eegtag,obj,pretrigger,posttrigger,plottype,eeg_classification_on,eeg_classification);
            end
        else
            fprintf('File ''%s'' does not contain patch channel ''%s''\n',file.tag,patchtag);
        end
    end

    function plot_eeg3(file,wf,eegtag,obj,pretrigger,posttrigger,plottype,eeg_classification_on,eeg_classification)
        spiketimes = wf.gettimes(0,inf);
        eegc = file.signals.get('tag',eegtag);%load(file.filepath,'A_EEG');
        if eeg_classification_on
            eegcvalues = obj.modify_eeg(eeg_classification(1),eeg_classification(2),...
                eeg_classification(3),file);
        else
            eegcvalues = eegc.sc_loadsignal;
        end
        eegctimes = eegc.t;%(0:(numel(eegcvalues)-1))*eegc.A_EEG.interval;
        clear eeg
        vtags = {'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};
        
        matchstr1 = '333 ms ITI';
        matchstr2 = '1p ';
        triggers = file.gettriggers(0,inf);
        triggerstr = triggers.values('tag');
        pos = cellfun(@(x) strncmp(matchstr1,x,numel(matchstr1)),triggerstr);
        pos = pos | cellfun(@(x) strncmp(matchstr2,x,numel(matchstr2)),triggerstr);
        triggerstr = triggerstr(pos);
        electrodes = cell(length(vtags),1);
        if numel(triggerstr)
            figure('Units','Normalized','OuterPosition',[0 0 1 1]);
            for j=1:numel(triggerstr)
                txtmarkstart = triggers.get('tag',triggerstr{j}).gettimes(0,inf);
                if numel(txtmarkstart)==0
                    fprintf('No times for TextMark ''%s'' in file ''%s''\n',triggerstr{j},...
                        file.tag);
                else
                    for i=1:numel(txtmarkstart)
                        electrode_min_time = nan(numel(vtags),1);
                        for m=1:numel(vtags)
                            thisStim = file.stims.get('tag',vtags{m});
                            if numel(thisStim)
                                stimtimes = thisStim.triggers.get(1).gettimes(0,inf);
                                stimtimes = stimtimes - txtmarkstart(i);
                                mintime = min(stimtimes(stimtimes>=0));
                            end
                            if isempty(mintime),    mintime = inf;  end
                            electrode_min_time(m) = mintime;
                            if isempty(electrode_min_time(m)),  electrode_min_time(m) = inf;    end
                        end
                        [~,ind] = min(electrode_min_time);
                        electrode = triggers.get('tag',vtags{ind});
                        electrode_min_time(ind) = inf;
                        stimtimes = electrode.gettimes(0,inf);
                        stimtimes = stimtimes(stimtimes>=txtmarkstart(i) & stimtimes<txtmarkstart(i)+min(electrode_min_time));
                        electrodes(ind) = {[electrodes{ind}; stimtimes]};
                    end
                end
            end
            figname = sprintf('%s_%s',file.tag,wf.tag);
            set(gcf,'Name',figname)
            for j=1:numel(electrodes)
                h1=subplot(numel(electrodes),4,(j-1)*4+1);%sc_square_subplot(numel(triggerstr)*3,(k-1)*3+1);
                h2=subplot(numel(electrodes),4,(j-1)*4+2);%sc_square_subplot(numel(triggerstr)*3,(k-1)*3+2);
                h3=subplot(numel(electrodes),4,(j-1)*4+3);%sc_square_subplot(numel(triggerstr)*3,(k-1)*3+3);
                h4=subplot(numel(electrodes),4,(j-1)*4+4);
                stimtimes = electrodes{j};
                eegtype = interp1(eegctimes,eegcvalues,stimtimes);
                
                if ~plottype
                    f=sc_perihist(h1,stimtimes(eegtype<-2.5),spiketimes,pretrigger,posttrigger,binwidth);
                else
                    f=sc_kernelhist(h1,stimtimes(eegtype<-2.5),spiketimes,pretrigger,posttrigger,binwidth,'bandwidth',bandwidth);
                end
                
                if ~nnz(f), set(h1,'xtick',[],'ytick',[]); end
                if ~plottype
                    f=sc_perihist(h2,stimtimes(eegtype>=-2.5 & eegtype<=2.5),spiketimes,pretrigger,posttrigger,binwidth);
                else
                    f=sc_kernelhist(h2,stimtimes(eegtype>=-2.5 & eegtype<=2.5),spiketimes,pretrigger,posttrigger,binwidth,'bandwidth',binwidth);
                end
                if ~nnz(f), set(h2,'xtick',[],'ytick',[]); end
                if ~plottype
                    f=sc_perihist(h3,stimtimes(eegtype>2.5 & eegtype<=7.5),spiketimes,pretrigger,posttrigger,binwidth);
                else
                    f=sc_kernelhist(h3,stimtimes(eegtype>2.5 & eegtype<=7.5),spiketimes,pretrigger,posttrigger,binwidth,'bandwidth',binwidth);
                end
                if ~nnz(f), set(h3,'xtick',[],'ytick',[]); end
                if ~plottype
                    f=sc_perihist(h4,stimtimes(eegtype>7.5),spiketimes,pretrigger,posttrigger,binwidth);
                else
                    f=sc_kernelhist(h4,stimtimes(eegtype>7.5),spiketimes,pretrigger,posttrigger,binwidth,'bandwidth',binwidth);
                end
                if ~nnz(f), set(h4,'xtick',[],'ytick',[]); end
                xlim(h1,[pretrigger posttrigger]);
                xlim(h2,[pretrigger posttrigger]);
                xlim(h3,[pretrigger posttrigger]);
                xlim(h4,[pretrigger posttrigger]);
                xlabel(h2,vtags{j});
                ylabel(h1,sprintf('N = %i', nnz(eegtype<-2.5)));
                ylabel(h2,sprintf('N = %i',nnz(eegtype>=-2.5 & eegtype<=2.5)));
                ylabel(h3,sprintf('N = %i',nnz(eegtype>2.5 & eegtype<=7.5)));
                ylabel(h4,sprintf('N = %i',nnz(eegtype>7.5)));
                if j==1
                    title(h1,sprintf('%s/%s, EEG < -2.5', file.tag,wf.tag));
                    title(h2,'-2.5 <= EEG <= 2.5');
                    title(h3,'EEG > 2.5 <= 7.5');
                    title(h4,'EEG > 7.5');
                end
            end
            %    print('-djpeg100',figname)
        end
    end
end

