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
global DEBUG
DEBUG = 0;
addpath layout\ sensorimotor\classes\ sensorimotor\gui\ sensorimotor\functions\ third-party\ ...
    viewers\ panelcomponents\ panels\ channelaxes\ enumtypes\ uiobjects\ utility\

close all
if ~isempty(findall(0,'type','figure'))
    return
end
args = varargin;

if  exist('sc_confiq.txt','file') == 2
    fid = fopen('sc_confiq.txt');
    search_dir = fgetl(fid);
    data_dir = fgetl(fid);
    if ~numel(args)
        str = fgetl(fid);
        if ischar(str)
            filename = [search_dir '\' str];
            if exist(filename,'file') == 2
                args = {filename};
            end
        end
    end
    fclose(fid);
else
    search_dir = [];
    data_dir = [];
end

if ~ischar(search_dir), search_dir = [];    end
if ~ischar(data_dir),   data_dir = [];      end

if ~numel(args) || strcmpi(args{1},'-loadnew')
    [fname, pname] = uigetfile('*_sc.mat','Choose experiment file',search_dir);
    filename = fullfile(pname,fname);
    if exist(filename,'file') == 2
        args = {filename};
    else
        fprintf('Could not detect file\n');
        return
    end
end

if strcmpi(args{1},'-addpath')
    return
elseif strcmpi(args{1},'-help')
    help(mfilename)
    return
elseif strcmpi(args{1},'-newsp2') || strcmpi(args{1},'-newadq')
    fdir = uigetdir;
    if isnumeric(fdir), return, end
    
    experiment = ScExperiment('fdir',fdir);
    guimgr = GuiManager();
    guimgr.viewer.data_dir = data_dir;
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
        guimgr.viewer.has_unsaved_changes = ~experiment.sc_save();
        guimgr.show;
    end
elseif numel(args{1}) && args{1}(1) == '-'
    msgbox(['Illegal command : ' args{1}]);
    return;
else
    if exist(args{1},'file') == 2
        filename = args{1};
    else
        [fname, pname] = uigetfile('*_sc.mat','Choose experiment file');
        filename = fullfile(pname,fname);
        if exist(filename,'file') ~= 2
            fprintf('Could not detect file\n');
            return;
        end
    end
    guimgr = GuiManager();
    if numel(args)>=2
        data_dir = args{2};
    end
    guimgr.viewer.data_dir = data_dir;
    d = load(filename);
    
    guimgr.viewer.search_dir = fileparts(filename);
    experiment = d.obj;
    clear d
    guimgr.experiment = experiment;
    guimgr.show;
end

end
