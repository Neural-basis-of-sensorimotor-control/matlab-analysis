function val = get_default_experiment_dir()

global INTRA_EXPERIMENT_DIR

if isempty(INTRA_EXPERIMENT_DIR)
  
  INTRA_EXPERIMENT_DIR = read_sc_settings('intra_experiment_dir');
  
end

if ~isempty(INTRA_EXPERIMENT_DIR) && INTRA_EXPERIMENT_DIR(end) ~= filesep
  INTRA_EXPERIMENT_DIR(end+1) = filesep;
end

val = INTRA_EXPERIMENT_DIR;

end