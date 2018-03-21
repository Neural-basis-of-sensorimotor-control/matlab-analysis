function experiment = load_experiment(full_file_path)

filepath = sc_file_loader.get_experiment_file(full_file_path);

if ~isempty(filepath)
  
  d = load(filepath, 'obj');
  experiment = d.obj;
  experiment.save_name = sc_settings.get_last_experiment();

end

end