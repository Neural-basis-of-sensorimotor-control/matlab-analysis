function [file, full_file_path] = get_last_experiment()

global LAST_EXPERIMENT

if isempty(LAST_EXPERIMENT)
  
  LAST_EXPERIMENT = read_sc_settings('last_experiment');
  
end

file = LAST_EXPERIMENT;

if nargout>=2
  full_file_path = [get_default_experiment_dir() LAST_EXPERIMENT];
end

end