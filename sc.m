function sc(varargin)
%SC View Spike2 or binary files from experiment
%   SC (without arguments) opens file dialog to load experiment file
%   (i.e. 'ABCD_sc.mat').
%
%   SC FILEPATH load experiment file that is found at FILEPATH
%
%   SC -NEWSP2 create new experiment file from exported Spike2 files.
%   Full instructions:
%   1. In Spike2, run scipt 'smr to mat.s2s'. Select a folder. All the Spike2
%   files in that folder will be converted to .mat files.
%   2. Run command SC -NEWSP2 in Matlab.
%   a) Select folder with .mat files.
%   b) Save new experiment file (e.g. 'C:\Documents\ABCD_sc.mat')
%   c) When the experiment file is opened, the experiment protocol can be
%   parsed and all comments can be included in each file. This can be done
%   any time once the file is created.
%   
%   SC -NEWADQ create experiment file from .adq-files
%
%   Copyright 2014 Neural Basis of Sensorimotor Control, Lund University
%   hannes.mogensen@med.lu.se

addpath layout\ sensorimotor\classes\ sensorimotor\gui\ sensorimotor\functions\ third-party\ ...
    viewers\ panelcomponents\ panels\ channelaxes\ enumtypes\ uiobjects\ utility\

args = varargin;
guimgr = [];

if ~numel(args)
    [fname, pname] = uigetfile('*_sc.mat','Choose experiment file');
    if exist(fullfile(pname,fname),'file') == 2
        d = load(fullfile(pname,fname));
        guimgr = GuiManager();
        guimgr.experiment = d.obj;
        clear d;
    else
        msgbox('Could not detect file');
        return;
    end
elseif strcmpi(args{1},'-addpath')
    return
elseif strcmpi(args{1},'-help')
    help(mfilename)
    return
elseif strcmpi(args{1},'-newsp2') || strcmpi(args{1},'-newadq')
    fdir = uigetdir;
    if isnumeric(fdir), return, end
    
    experiment = ScExperiment('fdir',fdir);
    guimgr = GuiManager();
    guimgr.experiment = experiment;
    if strcmpi(args{1},'-newsp2')
        files = what(fdir);
        rawdatafiles = cellfun(@(x) cell2mat(regexp(x,'^[\w]{1,1}[A-Z]{3,3}[0-9]{4,4}\.mat.{0,0}','match')), files.mat, 'UniformOutput',false);
    else  %adq
        files = dir(fdir);
        rawdatafiles = cellfun(@(x) cell2mat(regexp(x,'^[A-Z]{3,3}[0-9]{5,5}\.ADQ.{0,0}','match')), {files.name}, 'UniformOutput',false);
    end
    rawdatafiles = rawdatafiles(cellfun(@(x) ~isempty(x),rawdatafiles));
    for i=1:numel(rawdatafiles)
        fprintf('scanning file %i out of %i\n',i,numel(rawdatafiles));
        file = ScFile(experiment, rawdatafiles{i});
        if strcmpi(args{1},'-newsp2')
            [~,name] = fileparts(rawdatafiles{i});
            spikefiles = cellfun(@(x) cell2mat(regexp(x,['^' name '_\w*\.mat.{0,0}'],'match')), files.mat, 'UniformOutput',false);
            file.spikefiles = spikefiles(cellfun(@(x) ~isempty(x), spikefiles));
        end
        file.init();
        experiment.add(file);
    end
    if ~experiment.n
        msgbox('No data of requested type in directory. Use sc -newadq for .ADQ files, and sc -newsp2 for imported spike2 files.');
        return;
    else
        guimgr.has_unsaved_changes = ~experiment.sc_save();
    end
elseif numel(args{1}) && args{1}(1) == '-'
    msgbox(['Illegal command : ' args{1}]);
    return;
else
    if exist(args{1},'file') == 2
        d = load(args{1});
        experiment = d.obj;
        clear d;
    else
        [fname, pname] = uigetfile('*_sc.mat','Choose experiment file');
        if exist(fullfile(pname,fname),'file') == 2
            d = load(fullfile(pname,fname));
            experiment = d.obj;
            clear d;
        else
            msgbox('Could not detect file');
            return;
        end
    end
    guimgr = GuiManager();
    guimgr.experiment = experiment;
end

if ~isempty(guimgr)    
    guimgr.show;
end

end

% function check_if_updated(experiment)
% for i=1:experiment.n
%     file = experiment.get(i);
%     for j=1:file.n
%         if any(cellfun(@(x) isempty(x),file.values('tmax')))
%             answer = questdlg(['It appears that the experiment file was '...
%                 'created with a previous version of the sensorimotor '...
%                 'toolbox. Load protocol file again to update?'],...
%                 'Yes','Abort','Yes');
%             switch answer
%                 case 'Yes'
%                     [protocolfile, pdir] = uigetfile('*.txt','Select protocol file');
%                     protocolfile = fullfile(pdir, protocolfile);
%                     experiment.update_from_protocol(protocolfile);
%                     experiment.sc_save();                    
%                 case 'Abort'
%                 otherwise
%                     error(['Debugging error: unknown: ' answer])
%             end
%             return
%         end
%     end
% end
%end