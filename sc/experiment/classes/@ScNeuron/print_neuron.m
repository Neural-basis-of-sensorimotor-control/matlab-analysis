function print_neuron(obj)

fprintf('\n');

fprintf('''%s''    ', obj.experiment_filename);
fprintf('''%s''    ', obj.file_tag);
fprintf('''%s''    ', obj.signal_tag);
fprintf('...\n');

fprintf('%g    ', obj.tmin);
fprintf('%g    ', obj.tmax);
fprintf('...\n');

fprintf('{[');
fprintf('%g ', cell2mat(obj.x(1)))
fprintf(']');
fprintf('...\n');

fprintf('[');
fprintf('%g ', cell2mat(obj.x(2)))
fprintf(']} ');
fprintf('...\n');

fprintf('{[');
fprintf('%g ', cell2mat(obj.y(1)))
fprintf(']');
fprintf('...\n');

fprintf('[');
fprintf('%g ', cell2mat(obj.y(2)))
fprintf(']} ');
fprintf('...\n');

fprintf('{');
for i=1:length(obj.template_tag)
  fprintf('''%s'' ', obj.template_tag{i});
end
fprintf('} ');
fprintf('''%s''', obj.comment);
fprintf(' ...\n')

fprintf(' ''%s''', obj.p_protocol_signal_tag);

end