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
%   SC FILEPATH FILE_TAG  load experiment file found at FILEPATH, open file
%                         with tag FILE_TAG
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
close_viewer()

if viewer_is_running()
  return
end

args = varargin;

if ~isfile(get_sc_settings_filename())
  clear_sc_settings();
end

[~, experiment_path] = get_last_experiment();

if ~nargin && isfile(experiment_path)
  args = {experiment_path};
end

if ~numel(args) || strcmpi(args{1}, '-loadnew')
  
  %Ignore previous experiment
  
  [fname, pname] = uigetfile('*_sc.mat','Choose experiment file', ...
    get_default_experiment_dir());
  
  filename = fullfile(pname, fname);
  
  if isfile(filename)
    
    args = {filename};
    set_default_experiment_dir(pname);
    set_last_experiment(fname);
    
  else
    
    fprintf('Could not detect file\n');
    return
  
  end
  
end


if strcmpi(args{1}, '-help')
  
  help(mfilename)

elseif strcmpi(args{1}, '-what')
  directory = uigetdir(get_default_experiment_dir(), 'Select file directory');
  
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
  
elseif strcmpi(args{1}, '-newsp2') || strcmpi(args{1}, '-newadq')
  
  %Create new *_sc.mat file
  experiment = ScExperiment();
  
  if strcmpi(args{1}, '-newsp2')
    
    ending = '*.mat';
    
  else  %adq
    
    ending = '*.adq';
    
  end
  
  [rawdatafiles, raw_data_folder] = uigetfile(ending, ...
    'Select all files with analog channels to be included', ...
    get_raw_data_dir(), 'MultiSelect', 'on');
  
  if ~iscell(rawdatafiles)
    rawdatafiles = {rawdatafiles};
  end
  
  set_raw_data_dir(raw_data_folder);
  experiment.set_fdir(raw_data_folder);
  rawdatafiles = rawdatafiles(cellfun(@(x) ~isempty(x), rawdatafiles));
  
  for i=1:numel(rawdatafiles)
    
    fprintf('scanning file %i out of %i\n', i, numel(rawdatafiles));
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
    
    guimgr.experiment    = experiment;
    experiment_name      = experiment.get(1).tag;
    experiment_tag       = experiment_name(1:end-4);
    experiment_name      = [experiment_tag '_sc'];
    experiment.save_name = experiment_tag;
    
    if ~experiment.save_experiment(experiment_name, false)
    
      msgbox('Experiment not saved. Aborting');
    
    else
      
      guimgr.show;
      assignin('base', 'h', guimgr);
      assignin('base', 'expr', experiment);
    
    end
  end
  
elseif strcmpi(args{1},'-version')
  
  fprintf('See <a href="%s">GitHub</a> for additional information.\n', github_url);
  
elseif strcmpi(args{1}, '-amplitude')
  
  args = args(2:end);
  gui = sc(args{:});
  gui.mode = ScGuiState.ampl_analysis;
  
elseif numel(args{1}) && args{1}(1) == '-'
  
  fprintf(['Illegal command : ' args{1}]);
  
else
  
  if isfile(args{1})
    
    filename = args{1};
  
  else
    
    [fname, pname] = uigetfile('*_sc.mat', 'Choose experiment file');
    filename = fullfile(pname, fname);
    
    if ~isfile(filename)
    
      fprintf('Could not detect file\n');
      return;
    
    end
    
  end
  
  guimgr = GuiManager();
  
  if nargout
    gui = guimgr;
  end
  
  set_default_experiment_dir(filename);
  guimgr.experiment = ScExperiment.load_experiment(filename);
  guimgr.show;
  
  if length(args)>1
    
    guimgr.viewer.set_file(args{2});
  
  end
  
  assignin('base','h',guimgr);
  assignin('base','expr', guimgr.viewer.experiment);
  
end

end
