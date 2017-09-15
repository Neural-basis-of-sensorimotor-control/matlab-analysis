function next_neuron(obj)

neuron = obj.neuron;

fprintf('\n');

fprintf('''%s''    ', neuron.experiment_filename);
fprintf('''%s''    ', neuron.file_tag);
fprintf('''%s''    ', neuron.signal_tag);
fprintf('...\n');

fprintf('%g    ', neuron.tmin);
fprintf('%g    ', neuron.tmax);
fprintf('...\n');

fprintf('{[');
fprintf('%g ', cell2mat({obj.clicked_points.x}))
fprintf(']');
fprintf('...\n');

fprintf('[');
fprintf(']} ');
fprintf('...\n');

fprintf('{[');
fprintf('%g ', cell2mat({obj.clicked_points.y}))
fprintf('] ');
fprintf('...\n');

fprintf('[');
fprintf(']} ');
fprintf('...\n')
fprintf('{');
for i=1:length(neuron.template_tag)
  fprintf('''%s'' ', neuron.template_tag{i});
end
fprintf('} ');
fprintf('''%s''', neuron.comment);

fprintf('\n')
fprintf('\n')

ind_neuron = find(obj.neuron == obj.neurons);
obj.neuron = obj.neurons(ind_neuron + 1);
plot_neuron(obj);

end