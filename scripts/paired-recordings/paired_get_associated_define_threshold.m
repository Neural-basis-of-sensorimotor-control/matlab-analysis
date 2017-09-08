function [threshold, neuron] = paired_get_associated_define_threshold(fig)

threshold = get_userdata(fig, 'define_threshold');
neuron    = get_userdata(fig, 'neuron');

end