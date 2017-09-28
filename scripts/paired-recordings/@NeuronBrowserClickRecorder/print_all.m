function print_all(obj)

for i=1:length(obj.neurons)
  
  print_neuron(obj.neurons(i));
  fprintf('\n\n');
  
end

end