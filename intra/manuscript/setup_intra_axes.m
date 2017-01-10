function setup_intra_axes(neurons, stims)

axis tight
xlabel('Stims')
ylabel('Neurons')
% set(gca, 'XTick', 1:length(stims), 'XTickLabel', stims, ...
%   'XTickLabelRotation', 270,  ...
%   'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_str});

end