function signal = sc_load_signal(experiment_file, file_tag, ...
  signal_tag, varargin)

if (isa(experiment_file, 'struct') || isa(experiment_file, 'ScNeuron')) && ...
    nargin == 1 && length(experiment_file) > 1
  
  neuron = experiment_file;
  signal = [];
  
  for i=1:length(neuron)
    signal = add_to_list(signal, sc_load_signal(neuron(i)));
  end

  return
  
end

if isa(experiment_file, 'struct') || isa(experiment_file, 'ScNeuron')
  
  sc_dir = get_default_experiment_dir;
  neuron = experiment_file;
  
  if nargin==1

      signal = sc_load_signal([sc_dir neuron.experiment_filename], neuron.file_tag, ...
        neuron.signal_tag);
          
  elseif nargin==2
    
    signal = sc_load_signal([sc_dir neuron.experiment_filename], neuron.file_tag, ...
      neuron.signal_tag, file_tag);
  
  elseif nargin==3
  
    signal = sc_load_signal([sc_dir neuron.experiment_filename], neuron.file_tag, ...
      neuron.signal_tag, file_tag, signal_tag);
  
  else
    
    signal = sc_load_signal([sc_dir neuron.experiment_filename], neuron.file_tag, ...
      neuron.signal_tag, file_tag, signal_tag, varargin{:});
  
  end
    
else
  
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
    experiment_file = fullfile(pname, fname);
  end
  expr = ScExperiment.load_experiment(experiment_file);
  
  if ~exist('file_tag', 'var')
    file_tag = input('File tag: ','s');
  end
  file = expr.get('tag',file_tag);
  if check_raw_data_dir && ~file.prompt_for_raw_data_dir()
    return
  end
  
  if ~exist('signal_tag', 'var')
    signal_tag = input('signal channel (patch / patch2): ', 's');
  end
  signal = file.signals.get('tag',signal_tag);
end

signal.update_property_values();

end