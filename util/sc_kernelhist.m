function [f,t,h] = sc_kernelhist(varargin)
%SC_KERNELHIST(stimtimes,spiketimes,pretrigger,posttrigger,binwidth)
%SC_KERNELHIST(axeshandle,stimtimes,spiketimes,pretrigger,posttrigger,binwidth)
%SC_KERNELHIST(...,ksdensityargs)
if ishandle(varargin{1})
    axeshandle = varargin{1};
    offset = 1;
else
    axeshandle = gca;
    offset = 0;
end
stimtimes = varargin{offset+1};
spiketimes = varargin{offset+2};
pretrigger = varargin{offset+3};
posttrigger = varargin{offset+4};
binwidth = varargin{offset+5};
ksdensityargs  = varargin(offset+6:end);
[freq, edges] = temp_neuro.sc_kernelfreq(stimtimes,spiketimes,pretrigger,posttrigger,binwidth,ksdensityargs{:});
plothandle = plot(axeshandle,edges,freq);
if nargout>=1,  f = freq;       end
if nargout>=2,  t=edges;        end
if nargout>=3,  h=plothandle;   end
end