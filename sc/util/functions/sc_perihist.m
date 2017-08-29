function [freq_out, edges_out, plot_out] = sc_perihist(varargin)
% SC_PERIHIST(stimtimes, spiketimes, pretrigger, posttrigger, binwidth)
% SC_PERIHIST(axeshandle, ...)
% [freq_out, edges_out, plot_out] = SC_PERIHIST(...)

if ishandle(varargin{1})

  ax         = varargin{1};
  arg_offset = 1;
  
else
  
  ax         = gca;
  arg_offset = 0;

end

stimtimes   = varargin{arg_offset+1};
spiketimes  = varargin{arg_offset+2};
pretrigger  = varargin{arg_offset+3};
posttrigger = varargin{arg_offset+4};
binwidth    = varargin{arg_offset+5};

[freq, edges] = sc_perifreq(stimtimes,spiketimes,pretrigger,posttrigger,binwidth);

plot_h = plot(ax, edges, freq);

if nargout >= 1
  freq_out = freq;   
end

if nargout >= 2
  edges_out = edges;
end

if nargout >= 3
  plot_out = plot_h;
end