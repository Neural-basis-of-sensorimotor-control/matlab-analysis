function [str_layer, layer_enumeration] = paired_get_layer(neuron)

layer_enumeration = {'Layer II - III' 'Layer V'};

if ~nargin && nargout >= 2
  str_layer = '';
  return
end

depth_mm = paired_parse_for_subcortical_depth(neuron);

if strcmp(neuron.signal_tag, 'patch')  
  depth_mm = depth_mm.depth1;
elseif strcmp(neuron.signal_tag, 'patch2')
  depth_mm = depth_mm.depth2;
else
  error('Unknown signal tag: %s\n', neuron.signal_tag);
end


if depth_mm <= 0
  error('Non-positive depth denotation');
elseif depth_mm < .8
  str_layer = layer_enumeration{1};
else
  str_layer = layer_enumeration{2};
end

end
