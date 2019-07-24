% INPUT: 
%   v
%   stim_times
% CONSTANTS:
%   pretrigger
%   posttrigger
%   xlimits
%   ylimits
%   lower_cutoff
%   upper_cutoff
%
% OUTPUTS:
%   templates for different EPSPs
% 
% step through stim_times:
%   1. Extract t, v
%   2. Bandpass filter t, v -> v_filtered
%   3. Detect EPSPs in time range (? see plot below)
%   4. Plot t, v 
%   5. Plot t, v_filtered
%   6. Plot detected EPSPs
%   7. Zoom with xlimits, ylimits
%   8. If new EPSPs are detected, add thresholds. Save continuously
%
%
% Plot detected EPSPs on top of each other, cluster manually


