function [freq_out, edges_out, plot_out] = sc_kernelhist(varargin)
%SC_KERNELHIST(stimtimes, spiketimes, pretrigger, posttrigger, kernelwidth, binwidth)
%SC_KERNELHIST(axeshandle, ...)
%SC_KERNELHIST(suppress_plot, axeshandle, ...)
%SC_KERNELHIST(...,ksdensityargs)

suppress_plot = false;

if islogical(varargin{1})
  
  suppress_plot = varargin{1};
  varargin = varargin(2:end);

end

if ~suppress_plot  
  axeshandle = gca;
end

if ishandle(varargin{1})
  
  axeshandle = varargin{1};
  varargin   = varargin(2:end);

end

stimtimes     = varargin{1};
spiketimes    = varargin{2};
pretrigger    = varargin{3};
posttrigger   = varargin{4};
kernelwidth   = varargin{5};
ksdensityargs = varargin(6:end);

[freq, edges] = sc_kernelfreq(stimtimes, spiketimes, pretrigger, posttrigger, ...
  kernelwidth, ksdensityargs{:});

if ~suppress_plot
  plothandle = plot(axeshandle,edges,freq);
else
  plothandle = [];
end

if nargout>=1
  freq_out = freq;
end

if nargout>=2
  edges_out=edges;
end

if nargout>=3
  plot_out=plothandle;
end

end
