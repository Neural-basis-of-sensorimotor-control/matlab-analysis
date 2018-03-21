function [pattern_times, str_pattern]  = paired_get_pattern_times(neuron)

str_pattern = get_patterns();
str_pattern = str_pattern(~startsWith(str_pattern, '1p electrode'));

expr = ScExperiment.load_experiment(expr_fname);

file = get_item(expr.list, neuron.file_tag);
triggers = file.gettriggers(0, inf);

patterns = get_items(triggers.cell_list, 'tag', str_pattern);
pattern_times = get_values(patterns, @(x) x.gettimes(0,inf));

end