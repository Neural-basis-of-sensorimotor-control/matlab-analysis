function params = paired_automatic_deflection_detection(neuron)

if length(neuron) ~= 1
  
  fig = gcf;
  clf
  
  subplot(2, 3, 1)
  title('Pretrigger peak time')
  xlabel('Time (s)')
  ylabel('Depth (mm)')
  hold on
  grid on
  
  subplot(2, 3, 2)
  title('Peritrigger peak time')
  xlabel('Time (s)')
  hold on
  grid on
  
  subplot(2, 3, 3)
  title('Posttrigger peak time')
  xlabel('Time (s)')
  hold on
  grid on
  
  subplot(2, 3, 4)
  title('Pretrigger peak amplitude')
  xlabel('Normalized frequency')
  ylabel('Depth (mm)')
  hold on
  grid on
  
  subplot(2, 3, 5)
  title('Peritrigger peak amplitude')
  hold on
  grid on
  xlabel('Normalized frequency')
  
  subplot(2, 3, 6)
  title('Posttrigger peak amplitude')
  hold on
  grid on
  xlabel('Normalized frequency')
  
  params = vectorize_fcn(@paired_automatic_deflection_detection, neuron);
  
  add_legend(fig, true, false);
  
  return
  
end

[t1, t2] = paired_get_neuron_spiketime(neuron);

params    = cell(2,1);
params(1) = {plot_result(neuron, t1, t2)};
params(2) = {plot_result(neuron, t2, t1)};

end

function params = plot_result(neuron, t1, t2)

[indx, lowpass_freq, lowpass_t, highpass_freq, ~, avg_freq] = paired_get_automatic_detection(t1, t2);

depths = paired_parse_for_subcortical_depth(neuron);

if strcmp(neuron.protocol_signal_tag, 'patch') || strcmp(neuron.protocol_signal_tag, 'patch1')
  depth = depths.depth1;
elseif strcmp(neuron.protocol_signal_tag, 'patch2')
  depth = depths.depth2;
else
  error('Unknown tag: %s', neuron.protocol_signal_tag);
end

subplot(2, 3, 1)
plot(lowpass_t(indx(2)), -depth, '+', 'Tag', neuron.file_tag, ...
  'LineWidth', 2, 'MarkerSize', 12)

subplot(2, 3, 2)
plot(lowpass_t(indx(4)), -depth, '+', 'Tag', neuron.file_tag, ...
  'LineWidth', 2, 'MarkerSize', 12)

subplot(2, 3, 3)
plot(lowpass_t(indx(6)), -depth, '+', 'Tag', neuron.file_tag, ...
  'LineWidth', 2, 'MarkerSize', 12)

subplot(2, 3, 4)
plot(.5*(2*lowpass_freq(indx(2)) - lowpass_freq(indx(1)) - lowpass_freq(indx(3)))/avg_freq, ...
  -depth, '+', 'Tag', neuron.file_tag, 'LineWidth', 2, 'MarkerSize', 12)

subplot(2, 3, 5)
plot(.5*(2*highpass_freq(indx(4)) - lowpass_freq(indx(3)) - lowpass_freq(indx(5)))/avg_freq, ...
  -depth, '+', 'Tag', neuron.file_tag, 'LineWidth', 2, 'MarkerSize', 12)

subplot(2, 3, 6)
plot(.5*(2*lowpass_freq(indx(6)) - lowpass_freq(indx(5)) - lowpass_freq(indx(7)))/avg_freq, ...
  -depth, '+', 'Tag', neuron.file_tag, 'LineWidth', 2, 'MarkerSize', 12)


params = [
  lowpass_t(indx(1)) 
  lowpass_t(indx(3)) - lowpass_t(indx(1))
  lowpass_t(indx(2)) - lowpass_t(indx(1))
  (lowpass_freq(indx(2)) - .5*(lowpass_freq(indx(1)) + lowpass_freq(indx(3))))/avg_freq;
  
  lowpass_t(indx(3)) 
  lowpass_t(indx(5)) - lowpass_t(indx(3))
  lowpass_t(indx(4)) - lowpass_t(indx(3))
  (highpass_freq(indx(4)) - .5*(lowpass_freq(indx(3)) + lowpass_freq(indx(5))))/avg_freq;
  
  lowpass_t(indx(5))
  lowpass_t(indx(7)) - lowpass_t(indx(5))
  lowpass_t(indx(6)) - lowpass_t(indx(5))
  (lowpass_freq(indx(6)) - .5*(lowpass_freq(indx(5)) + lowpass_freq(indx(7))))/avg_freq;
  ];

end

