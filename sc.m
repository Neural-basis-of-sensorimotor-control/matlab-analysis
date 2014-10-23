function sc(varargin)
%SC View Spike2 or binary files from experiment
%   SC (without arguments) opens file dialog to load experiment file
%   (i.e. 'ABCD_sc.mat').
%   
%   SC -LOADNEW suppress autoloading of previous experiment file
%
%   SC -VERSION get versioning number
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
addpath(genpath(fileparts(mfilename('fullpath'))));
github_url = 'https://github.com/Neural-basis-of-sensorimotor-control/matlab-analysis/releases';
close all
if ~isempty(findall(0,'type','figure'))
    return
end
args = varargin;

if  exist('sc_config.txt','file') == 2
    fid = fopen('sc_config.txt');
    sc_file_folder = fgetl(fid);
    if isempty(sc_file_folder)
        sc_file_folder = cd;
    end
    raw_data_folder = fgetl(fid);
    if ~numel(args)
        str = fgetl(fid);
        if ischar(str)
            filename = [sc_file_folder '\' str];
            if exist(filename,'file') == 2
                args = {filename};
            end
        end
    end
    fclose(fid);
    if ~ischar(sc_file_folder), sc_file_folder = [];    end
    if ~ischar(raw_data_folder),   raw_data_folder = [];      end
else
    sc_file_folder = [];
    raw_data_folder = [];
end

if ~numel(args) || strcmpi(args{1},'-loadnew')
    %Force program to neglect sc_config.txt
    [fname, pname] = uigetfile('*_sc.mat','Choose experiment file',sc_file_folder);
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
    %Create new *_sc.mat file
    experiment = ScExperiment();
    if strcmpi(args{1},'-newsp2')
        [rawdatafiles,raw_data_folder] = uigetfile('*.mat','Select all files with analog channels to be included',raw_data_folder,'MultiSelect','on');
        if ~iscell(rawdatafiles),  rawdatafiles = {rawdatafiles};    end
    else  %adq
        [rawdatafiles,raw_data_folder] = uigetfile('*.adq','Select all files with analog channels to be included',raw_data_folder,'MultiSelect','on');
        if ~iscell(rawdatafiles),  rawdatafiles = {rawdatafiles};    end
    end
    experiment.fdir = raw_data_folder;
    rawdatafiles = rawdatafiles(cellfun(@(x) ~isempty(x),rawdatafiles));
    for i=1:numel(rawdatafiles)
        fprintf('scanning file %i out of %i\n',i,numel(rawdatafiles));
        file = ScFile(experiment, rawdatafiles{i});
        if strcmpi(args{1},'-newsp2')
            %Look for 'Pontus-style' files with spikes detected in Spike2 
            [~,name] = fileparts(rawdatafiles{i});
            spikefiles = cellfun(@(x) cell2mat(regexp(x,['^' name '_\w*\.mat.{0,0}'],'match')), rawdatafiles, 'UniformOutput',false);
            file.spikefiles = spikefiles(cellfun(@(x) ~isempty(x), spikefiles));
        end
        file.init();
        experiment.add(file);
    end
    if ~experiment.n
        msgbox('No files selected. Use sc -newadq for .ADQ files, and sc -newsp2 for imported spike2 files.');
        return;
    else
        guimgr = GuiManager();
        guimgr.experiment = experiment; 
        guimgr.viewer.has_unsaved_changes = ~experiment.sc_save();
        guimgr.show;
    end
elseif strcmpi(args{1},'-version')
    fprintf('Version number: >1.0.2\n');
    fprintf('Changes might have been added since last release\n');
    fprintf('See <a href="%s">GitHub</a> for additional information.\n',github_url);
elseif numel(args{1}) && args{1}(1) == '-'
    fprintf(['Illegal command : ' args{1}]);
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
    guimgr.viewer.set_sc_file_folder(sc_file_folder);
    guimgr.viewer.set_raw_data_folder(raw_data_folder);
    d = load(filename);
    
    experiment = d.obj;
    clear d
    guimgr.experiment = experiment;
    guimgr.show;
end

end
