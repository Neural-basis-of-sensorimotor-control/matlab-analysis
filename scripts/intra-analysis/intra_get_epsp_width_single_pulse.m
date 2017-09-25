function [val, neg_normalization] = intra_get_epsp_width_single_pulse...
  (amplitude, selection)

if nargin<2
  selection = 'all';
end

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

widths = amplitude.width;
heights = amplitude.height;

switch selection
  case 'all'
    mean_width = mean(widths);
  case 'positive'
    mean_width = mean(widths(heights>=0));
  case 'negative'
    mean_width = mean(widths(heights<0));
  otherwise
    error('Illegal option: %s', selection);
end

if isempty(mean_width)
  val = 0;
else
  val = mean_width / amplitude.parent.userdata.single_pulse_width(ind);
end

neg_normalization = false;

end
