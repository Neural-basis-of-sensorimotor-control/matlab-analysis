function [file, full_file_path] = get_last_experiment()

file = read_sc_settings('last_experiment');

if nargout>=2
  full_file_path = [get_default_experiment_dir() LAST_EXPERIMENT];
end

end