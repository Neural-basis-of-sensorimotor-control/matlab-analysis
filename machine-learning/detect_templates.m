% INPUT: 
%   v
%   stim_times
% CONSTANTS:
%   pretrigger
%   posttrigger
%   lower_cutoff
%   upper_cutoff
%
% OUTPUTS:
%   templates for different EPSPs
% 
% step through stim_times:
%   1. Extract t, v
%   2. Bandpass filter t, v -> v_filtered
%   3. Detect EPSPs in time range
%   4. Plot t, v 
%   5. Plot t, v_filtered
%   6. Plot detected EPSPs
