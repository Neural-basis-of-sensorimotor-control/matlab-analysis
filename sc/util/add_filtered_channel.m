function add_filtered_channel(experiment_filepath, file_filepath, signal_tag)

experiment_filepath = strrep(experiment_filepath, '/', filesep);
experiment_filepath = strrep(experiment_filepath, '\', filesep);

file_filepath       = strrep(file_filepath, '/', filesep);
file_filepath       = strrep(file_filepath, '\', filesep);

[pathstr, file_tag] = fileparts(file_filepath);

neuron = ScNeuron('experiment_filename', experiment_filepath);

expr = sc_load_experiment(neuron);
expr.set_fdir(pathstr);

file = expr.get('tag', file_tag);
signal = file.signals.get('tag', signal_tag);
signal.sc_loadtimes();

signal.update_property_values();

v = signal.get_v(true, true, true, true);

d = load(file_filepath);

tag_filtered_signal = [signal_tag '_filtered'];
d.(tag_filtered_signal) = d.(signal_tag);
d.(tag_filtered_signal).values = v;

%str_fields = fields(d);

save(file_filepath, '-struct', 'd');

end