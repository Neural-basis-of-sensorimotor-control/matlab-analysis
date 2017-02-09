clc
clear

stims = {
'flat fa#V3#2'
'2.0 sa#V3#12'
'2.0 sa#V3#11'
'2.0 fa#V3#2'
'2.0 fa#V3#1'
'1.0 sa#V3#6'
% '1.0 sa#V1#3'
% '1.0 sa#V1#2'
% %'1.0 sa#V3#3'
% %'1.0 fa#V2#5'
% %'1.0 fa#V3#9'
% '0.5 sa#V1#4'
% '0.5 fa#V1#5'
% %'flat sa#V3#4'
% 'flat sa#V1#1'
% % 'flat sa#V3#2'
% % 'flat sa#V3#1'
% % 'flat fa#V3#5'
% % 'flat fa#V3#2'
% % 'flat fa#V3#1'
% % '2.0 fa#V3#1'
% '1.0 sa#V1#2'
% '0.5 fa#V1#5'
};

neurons_str = {
  %'ILNR0001'
  'IKNR0000'
  %'IHNR0000'
  %'IFNR0002'
  'IDNR0001'
  'HRNR0000'
  'DJNR0005'
  'BONR0009'
  %'BJNR0005'
  %'ICNR0003'
  %'CANR0001'
};

neurons = get_intra_neurons;
neurons = get_items(neurons, 'file_tag', neurons_str);

clf reset
hold on

for i=1:length(neurons)
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(stims)
   stim = signal.amplitudes.get('tag', stims{j});
   x = stim.height;
   y = j*length(stims)*ones(size(x)) - i;
   plot(x, y, '.', 'Tag', neuron.file_tag);
  end
end

set(gca, 'Color', 'k');
title('Amplitude mV')
set(gca, 'YTick', length(stims)* ((1:length(stims))-.5), ...
  'YTickLabel', stims);
h = add_legend();
h.Color = 'w';
axis_wide(gca, 'y', [], 1, false);
grid on