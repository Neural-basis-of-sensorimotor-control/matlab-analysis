function [file, expr] = sc_load_file(neuron)

expr = sc_load_experiment(neuron);
file = expr.get('tag', neuron.file_tag);

end