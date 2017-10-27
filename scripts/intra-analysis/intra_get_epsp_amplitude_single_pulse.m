function [val, neg_normalization] = intra_get_epsp_amplitude_single_pulse...
  (amplitude, selection)

if nargin<2
  selection = 'all';
end

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));
norm_constant = amplitude.parent.userdata.single_pulse_height(ind);

heights = amplitude.height;

if ischar(selection)

switch selection
  case 'all'
    mean_height = mean(heights);
  case 'positive'
    mean_height = mean(heights(heights>=0));
  case 'negative'
    mean_height = mean(heights(heights<0));
  otherwise
    error('Illegal option: %s', selection);
end

else
  
  min_height   = selection;
  mean_height = mean(heights(heights>min_height));
  
end

if isempty(mean_height)
  val = 0;
else
  val = mean_height / abs(norm_constant);
end

neg_normalization = norm_constant < 0;

end

