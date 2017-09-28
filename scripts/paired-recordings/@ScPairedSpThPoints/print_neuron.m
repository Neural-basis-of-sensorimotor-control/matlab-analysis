function print_neuron(obj)

print_neuron@ScPairedNeuron(obj)
fprintf(' ...\n')

fprintf('{')

for i=1:length(obj.str_properties)
  
  fprintf('{');
  
  for j=1:2
    
    val = obj.(obj.str_properties{i});
    
    fprintf('[')
    
    fprintf('%d ', val{j});
    
    fprintf('] ')
    
  end
  
  fprintf('} ');
  
end

fprintf('}');

end