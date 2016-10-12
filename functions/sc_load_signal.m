function [signal, file, expr] = sc_load_signal(experiment_file, file_str, signal_str, varargin)

check_raw_data_dir = false;
for i=1:2:length(varargin)
  switch varargin{i}
    case 'check_raw_data_dir'
      check_raw_data_dir = varargin{i+1};
    otherwise
      error('Unknown option: %s', varargin{i});
  end
end

if ~exist('experiment_file', 'var')
  [fname, pname] = uigetfile('*_sc.mat');
  experiment_file = fullfile(pname, fname)
end
d = load(experiment_file);
expr = d.obj;

if ~exist('file_str', 'var')
  file_str = input('File tag: ','s')
end
file = expr.get('tag',file_str);
if check_raw_data_dir && ~file.check_fdir()
  return
end

if ~exist('signal_str', 'var')
  signal_str = input('signal channel (patch / patch2): ', 's')
end
signal = file.signals.get('tag',signal_str);

end