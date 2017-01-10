function plot_single_responses

clc
clear
set(0,'DefaultFigureWindowStyle','docked')

neurons = get_intra_neurons();
stims = get_intra_motifs();
is_response = generate_response_matrix(neurons, stims);
%stims = stims(all(is_response, 2));
%d = load('tpd2dedab7_fb6c_4fe3_b79f_327d3c208867');
%neurons = d.neurons; stims = d.stims;

% for i=1:length(neurons)
%   fprintf('%d out of %d\n', i, length(neurons));
% 	fig = figure(i);
%   clf(fig, 'reset');
%
% 	neuron = neurons(i);
% 	signal = sc_load_signal(neuron);
% 	%sc_square_subplot(length(neurons), i)
% 	hold on
%
% 	for j=1:length(stims)
%
%     if is_response(j,i)
%       stim_str = stims{j};
%       stim = signal.amplitudes.get('tag', stim_str);
%
%       for k=1:length(stim.height)
%         plot(stim.height(k), j, 'k.', 'Tag', neuron.file_str)
%       end
%     end
% 	end
% 	title(neuron.file_str)
% 	set(gca, 'YTick', 1:length(stims), 'YTickLabel', stims);
%   axis_wide(gca, 'xy', 0, 1, true);
% end
for i=1:length(stims)
  fig = figure(i);
  clf(fig, 'reset');
  hold(gca, 'on');
  grid(gca, 'on');
  title(gca, [stims{i} ' - normalized ampitude']);
  set(gca, 'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_str});
end

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons));
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  %sc_square_subplot(length(neurons), i)
  hold on
  
  for j=1:length(stims)
    
    figure(j);
    if is_response(j,i)
      stim_str = stims{j};
      stim = signal.amplitudes.get('tag', stim_str);
      
      str = strsplit(stim.tag, '#');
      str = str{2};
      ind = str2num(str(2));
      norm_constant = stim.parent.userdata.single_pulse_height(ind);
            
      for k=1:length(stim.height)
        plot(stim.height(k)/norm_constant, i, 'k.', ...
          'Tag', neuron.file_str, ...
          'ButtonDownFcn', @btn_dwn_fcn);
      end
    end
  end
end

for i=1:length(stims)
  figure(i);
  axis_wide(gca,'xy',0,1,false);
end

end

function btn_dwn_fcn(obj,~)  

fprintf('%s\t%s\n',  obj.Parent.Title.String, obj.Tag);  
obj.Color = 'r';
obj.MarkerSize = 12;

end