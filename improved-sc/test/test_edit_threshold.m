clc
close all
clipboard('copy', 'D:\raw_data\mat\BJNR140211')
clear classes
h = sc_tool.PlotManager;
%h.signal1.amplitudes.add(ScAmplitude(h.sequence, h.signal1, h.trigger, ...
%  {'t1','v1','t2','v2'}, 'dummy', 0));

h.plot_mode = sc_tool.PlotModeEnum.edit_threshold;