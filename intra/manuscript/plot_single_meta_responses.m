clc
clear
clf reset

[num, txt, data] = xlsread('projections_Cell_by_cell.xlsx')

patterns = {'0.5 fa', '0.5 sa', '1.0 fa', '1.0 sa', '2.0 fa', '2.0 sa', ...
  'flat fa', 'flat sa'}';

neurons_str = txt(3:end,1);
num = num(1:end-2,1:end-2);

nbr_of_indx = sum(num==7 | num==8, 2);
[nbr_of_indx, indx] = sort(nbr_of_indx);
neurons_str = neurons_str(indx);

fprintf('Number of patterns with value = 7 or 8\n');
for i=1:length(neurons_str)
  neuron = get_intra_neurons(neurons_str{i});
  fprintf('%s\t%d\n', neuron.file_tag, nbr_of_indx(i));
end