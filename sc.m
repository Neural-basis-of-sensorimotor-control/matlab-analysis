function viewer = sc(varargin)
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

github_url = 'https://github.com/Neural-basis-of-sensorimotor-control/matlab-analysis/releases';

if nargout
  viewer = [];
end

addpath(genpath(fileparts(mfilename('fullpath'))));

if ~isempty(varargin) && strcmpi(varargin{1}, '-addpath')
  return
end

if numel(varargin) && strcmpi(varargin{1}, '-eeg')
  
  viewer = Eeg;
  return
  
end

if ~sc_version_check()
  return
end

close_viewer()

if viewer_is_running()
  return
end

args = varargin;

if ~isfile(sc_settings.get_settings_filename())
  sc_settings.clear_file();
end

[~, experiment_path] = sc_settings.get_last_experiment();

if ~nargin && isfile(experiment_path)
  args = {experiment_path};
end

if isempty(args)
  
  filepath = sc_file_loader.get_experiment_file();
  
  if ~isempty(filepath)
    viewer = load_file({filepath});
  else
    viewer = [];
  end
  
  return;
  
end

if strcmpi(args{1}, '-loadnew')
  %Ignore previous experiment
  
  [str_file, str_dir] = uigetfile('*_sc.mat', 'Select experiment file', ...
    sc_settings.get_last_experiment());
  
  if ~ischar(str_file)
    return
  end
  
  filepath = sc_file_loader.get_filepath(str_file, str_dir, 1);
  
  if ~isempty(filepath)
    viewer = load_file({filepath});
  else
    viewer = [];
  end
  return
  
end

if strcmpi(args{1}, '-help')
  
  help(mfilename)
  return
  
end

if strcmpi(args{1}, '-what')
  
  print_experiments_in_dir();
  return
  
end

if strcmpi(args{1}, '-newsp2') || strcmpi(args{1}, '-newadq')
  
  viewer = create_new_experiment(args);
  return
  
end

if strcmpi(args{1}, '-version')
  
  fprintf('See <a href="%s">GitHub</a> for additional information.\n', github_url);
  return
  
end

if strcmpi(args{1}, '-amplitude')
  
  args = args(2:end);
  viewer = sc(args{:});
  viewer.mode = ScGuiState.ampl_analysis;
  return
  
end

if numel(args{1}) && args{1}(1) == '-'
  
  fprintf(['Illegal command : ' args{1}]);
  return
  
end

viewer = load_file(args);

end


function val = file_is_experiment(str)

val = numel(str)>7 && strcmpi(str(end-6:end), '_sc.mat');

end


function print_experiments_in_dir()

directory = uigetdir(sc_settings.get_default_experiment_dir(), 'Select file directory');

if ~isnumeric(directory)
  
  str_dir = what(directory);
  clc
  
  for k=1:numel(str_dir.mat)
    
    str_file = str_dir.mat{k};
    
    if file_is_experiment(str_file)
      
      d = load([directory filesep str_file]);
      d.obj.print_status();
      
    end
  end
end

end


function viewer = create_new_experiment(args)

viewer = [];

%Create new *_sc.mat file

if strcmpi(args{1}, '-newsp2')
  ending = '*.mat';
elseif strcmpi(args{1}, '-adq')
  ending = '*.adq';
else
  error('Illegal file ending: %s', args{1});
end

[rawdatafiles, raw_data_folder] = uigetfile(ending, ...
  'Select all files with analog channels to be included', ...
  sc_settings.get_raw_data_dir(), 'MultiSelect', 'on');

if ~iscell(rawdatafiles) && ~ischar(rawdatafiles)
  return
end

if ~iscell(rawdatafiles)
  rawdatafiles = {rawdatafiles};
end

experiment = ScExperiment('fdir', raw_data_folder);

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

  viewer = GuiManager();
  
  viewer.experiment    = experiment;
  experiment_name      = experiment.get(1).tag;
  experiment_tag       = experiment_name(1:end-4);
  experiment_name      = [experiment_tag '_sc'];
  experiment.save_name = experiment_tag;
  
  if ~experiment.save_experiment(experiment_name, false)
    
    msgbox('Experiment not saved. Aborting');
    
  else
    
    viewer.show;
    assignin('base', 'h', viewer);
    assignin('base', 'expr', experiment);
    
  end
end

end


function viewer = load_file(args)

viewer = [];

if isfile(args{1})
  
  filename = args{1};
  
else
  
  [fname, pname] = uigetfile('*_sc.mat', 'Choose experiment file');
  filename       = fullfile(pname, fname);
  
  if ~isfile(filename)
    
    fprintf('Could not detect file\n');
    return;
    
  end
  
end

viewer = GuiManager();

viewer.experiment = ScExperiment.load_experiment(filename);
viewer.show;

if length(args)>1
  viewer.viewer.set_file(args{2});
end

assignin('base','h',viewer);
assignin('base','expr', viewer.viewer.experiment);

end