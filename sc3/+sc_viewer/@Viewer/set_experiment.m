function set_experiment(obj, experiment)

obj.experiment = experiment;
obj.set_file(get_set_val(obj.get_files(), obj.file, 1));

end
