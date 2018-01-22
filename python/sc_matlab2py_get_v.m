function v = sc_matlab2py_get_v(experiment_filepath, file_filepath, channel_tag)

experiment_filepath = strrep(experiment_filepath, '/', filesep);
experiment_filepath = strrep(experiment_filepath, '\', filesep);

file_filepath       = strrep(file_filepath, '/', filesep);
file_filepath       = strrep(file_filepath, '\', filesep);

[pathstr, file_tag] = fileparts(file_filepath);

neuron = ScNeuron('experiment_filename', experiment_filepath);

expr = sc_load_experiment(neuron);
expr.set_fdir(pathstr);

file = expr.get('tag', file_tag);
signal = file.signals.get('tag', channel_tag);
signal.sc_loadtimes();

signal.update_property_values();

v = signal.get_v(true, true, true, true);

end