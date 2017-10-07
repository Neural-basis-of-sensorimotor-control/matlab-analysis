function neurons = paired_get_triple_neurons()

neurons = paired_get_extra_neurons();

ind = arrayfun(@(x) nnz(cellfun(@(y) strcmp(x.file_tag, y), {neurons.file_tag})) > 1, neurons);

neurons = neurons(ind);

end