function neurons = get_paired_ec_neurons()

data = {
'HRNR_sc.mat' 'HRNR0000'  'patch' -inf inf {'ic-spike-double-1', 'ec-spike-double-1'} ''
};

neurons = [];

for i=1:size(data, 1)
  
  n = ScNeuron(...
    'experiment_filename', data{i,1}, ...
    'file_tag',            data{i,2}, ...
    'signal_tag',          data{i,3}, ...
    'tmin',                data{i,4}, ...
    'tmax',                data{i,5}, ...
    'template_tag',        data{i,6}, ...
    'tag',                 sprintf('IntraNeuron%03d', i));
  
  neurons = add_to_list(n);
  
end

end
