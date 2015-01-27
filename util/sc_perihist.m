function [f,t] = sc_perihist(varargin)
%SC_PERIHIST(stimtimes,spiketimes,pretrigger,posttrigger,binwidth)
%SC_PERIHIST(axeshandle,stimtimes,spiketimes,pretrigger,posttrigger,binwidth)
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
binwidth  = varargin{offset+5};
[freq, edges] = temp_neuro.sc_perifreq(stimtimes,spiketimes,pretrigger,posttrigger,binwidth);

plot(axeshandle,edges,freq);
if nargout>=1,  f = freq;   end
if nargout>=2,  t=edges;    end