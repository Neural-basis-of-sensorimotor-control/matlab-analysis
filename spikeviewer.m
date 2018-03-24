function argout_viewer = spikeviewer(varargin)
%SPIKEVIEWER Graphical user interface to analyze data imported from Spike2
%
% SPIKEVIEWER
% SPIKEVIEWER -loadnew    Suppress auto-loading
% SPIKEVIEWER -resetfigs  Suppress repositioning of figures
%
% Created 2013-2018 by Hannes Mogensen, Neural Basis of Sensorimotor
% Control
% Downloadable at https://github.com/Neural-basis-of-sensorimotor-control/matlab-analysis/
% Free to use or modify with due acknowledgement

addpath(genpath(mfilename('fullpath')))

loadnew   = false;
resetfigs = false;

for i=1:length(varargin)
  
  switch lower(varargin{i})
    
    case '-loadnew'
      loadnew = true;
    case '-resetfigs'
      resetfigs = true;
    otherwise
      error('Unknown command %s', varargin{i})
  end
  
end

if nargout
  argout_viewer = [];
end

if ~sc_version_check()
  return
end

close_viewer();

if viewer_is_running()
  return
end

viewer = sc_tool.GuiManager();

if loadnew
  
  [str_file, str_dir] = uigetfile('*_sc.mat', 'Select experiment file', ...
    sc_settings.get_last_experiment());
  
  if ~ischar(str_file)
    return
  end
  
  experiment_path = sc_file_loader.get_filepath(str_file, str_dir, 1);
  
else
  
  [~, experiment_path] = sc_settings.get_last_experiment();
  
end

if isempty(experiment_path)
  return
end

viewer.experiment = ScExperiment.load_experiment(experiment_path);
viewer.show();

if ~resetfigs
  viewer.resize_figures();
end

if nargout
  argout_viewer = viewer;
end

assignin('base', 'h', viewer);

end