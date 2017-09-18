function paired_print_subcortical_depth(ec_neurons, ic_neurons)

fprintf('*** EC neurons ***\n');
print_neurons(ec_neurons);

fprintf('\n***IC neurons ***\n');
print_neurons(ic_neurons);

end


function print_neurons(neurons)

depth = paired_parse_for_subcortical_depth(neurons);

fprintf('File\tChannel\tpatch\tpatch2\n');

for i=1:length(depth)
  
  fprintf('%s\t', neurons(i).file_tag)
  fprintf('%s\t', neurons(i).signal_tag)
  print_depth(depth(i).depth1);
  print_depth(depth(i).depth2);
  fprintf('\n');
  
end

end


function print_depth(depth)

if depth == -1
  fprintf('#Error\t')
elseif isnan(depth)
  fprintf('-\t')
else
  fprintf('%g\t', depth);
end

end