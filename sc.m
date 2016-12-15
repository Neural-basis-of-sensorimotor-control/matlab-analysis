function gui = sc(varargin)
%SC View Spike2 or binary files from experiment
%   SC (without arguments) opens file dialog to load experiment file
%   (i.e. 'ABCD_sc.mat').
%
%   SC -ADDPATH update current path (necessary for using other functions
%   that also utilizes the ScExperiment classes
%
%   SC -LOADNEW suppress autoloading of previous experiment file
%
%   SC -AMPLITUDE load program in amplitude analysis mode
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
%   SC -WHAT print all available information about experiment files in
%   chosen directory
%
%   Copyright 2015 Neural Basis of Sensorimotor Control, Lund University
%   hannes.mogensen@med.lu.se
if nargout
  gui = [];    
end

addpath(genpath(fileparts(mfilename('fullpath'))));

if numel(varargin) && strcmpi(varargin{1},'-addpath')
  return
elseif numel(varargin) && strcmpi(varargin{1},'-eeg')
  gui = Eeg;
  return
end

if ~sc_version_check
  return
end

github_url = 'https://github.com/Neural-basis-of-sensorimotor-control/matlab-analysis/releases';
close all

if ~isempty(findall(0,'type','figure'))
  return
end

args = varargin;

if  exist('sc_config.txt','file') == 2
  fid = fopen('sc_config.txt');
  sc_file_folder = get_default_experiment_dir();

  if ~numel(args)
    str = fgetl(fid);
    if ischar(str)
      filename = fullfile(sc_file_folder, str);
      if isfile(filename)
        args = {filename};
      end
    end
  end
  fclose(fid);
  
  if ~ischar(sc_file_folder)
    sc_file_folder = get_default_experiment_dir();    
  end
else
  sc_file_folder = get_default_experiment_dir();
end

if isempty(sc_file_folder)
  sc_file_folder = get_default_experiment_dir();
end

if ~numel(args) || strcmpi(args{1}, '-loadnew')
  %Force program to neglect sc_config.txt
  [fname, pname] = uigetfile('*_sc.mat','Choose experiment file', sc_file_folder);
  filename = fullfile(pname,fname);
  
  if exist(filename, 'file')
    args = {filename};
  else
    fprintf('Could not detect file\n');
    return
  end
end


if strcmpi(args{1}, '-help')
  help(mfilename)
  return
elseif strcmpi(args{1}, '-what')
  directory = uigetdir(sc_file_folder,'Select file directory');
  
  if ~isnumeric(directory)
    w = what(directory);
    clc
    
    for k=1:numel(w.mat)
      f = w.mat{k};
  
      if numel(f)>7 && strcmpi(f(end-6:end),'_sc.mat')
        d = load([directory filesep f]);
        d.obj.print_status();
      end
    end
  end
elseif strcmpi(args{1},'-newsp2') || strcmpi(args{1},'-newadq')
  %Create new *_sc.mat file
  experiment = ScExperiment();
  
  if strcmpi(args{1},'-newsp2')
    [rawdatafiles, raw_data_folder] = uigetfile('*.mat', ...
      'Select all files with analog channels to be included', ...
      get_raw_data_folder(), 'MultiSelect','on');
  
    if ~iscell(rawdatafiles)
      rawdatafiles = {rawdatafiles};    
    end
  else  %adq
    [rawdatafiles, raw_data_folder] = uigetfile('*.adq', ...
      'Select all files with analog channels to be included', ...
      get_raw_data_folder(), ...
      'MultiSelect','on');
    
    if ~iscell(rawdatafiles)
      rawdatafiles = {rawdatafiles};    
    end
  end
  
  experiment.fdir = raw_data_folder;
  rawdatafiles = rawdatafiles(cellfun(@(x) ~isempty(x),rawdatafiles));
  
  for i=1:numel(rawdatafiles)
    fprintf('scanning file %i out of %i\n',i,numel(rawdatafiles));
    file = ScFile(experiment, rawdatafiles{i});
    file.init();
    experiment.add(file);
  end
  
  if ~experiment.n
    msgbox('No files selected. Use sc -newadq for .ADQ files, and sc -newsp2 for imported spike2 files.');
    return;
  else
    guimgr = GuiManager();
    
    if nargout
      gui = guimgr;   
    end
    
    guimgr.experiment = experiment;
    experiment_name = experiment.get(1).tag;
    experiment_name = [experiment_name(1:end-4) '_sc'];
    
    if ~save_experiment(experiment, experiment_name, true);
      msgbox('Experiment not saved. Aborting');
    else
      guimgr.show;
      assignin('base','h',guimgr);
      assignin('base','expr',experiment);
    end
  end
elseif strcmpi(args{1},'-version')
  fprintf('See <a href="%s">GitHub</a> for additional information.\n',github_url);
elseif strcmpi(args{1}, '-amplitude')
  gui_mgr = sc();
  gui_mgr.mode = ScGuiState.ampl_analysis;
elseif numel(args{1}) && args{1}(1) == '-'
  fprintf(['Illegal command : ' args{1}]);
  return
else
  
  if isfile(args{1})
    filename = args{1};
  else
    [fname, pname] = uigetfile('*_sc.mat', 'Choose experiment file', ...
      sc_file_folder);
    filename = fullfile(pname, fname);
    
    if ~exist(filename,'file')
      fprintf('Could not detect file\n');
      return;
    end
  end
  
  guimgr = GuiManager();
  
  if nargout
    gui = guimgr;   
  end
  
  d = load(filename);
  
  experiment = d.obj;
  clear d
  guimgr.experiment = experiment;
  guimgr.show;
  assignin('base','h',guimgr);
  assignin('base','expr',experiment);
end

end
