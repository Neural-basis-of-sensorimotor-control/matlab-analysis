clc
close all
%clipboard('copy', 'D:\raw_data\mat\BJNR140211')
clear classes
h = sc_tool.GuiManager();
%h.signal1.amplitudes.add(ScAmplitude(h.sequence, h.signal1, h.trigger, ...
%  {'t1','v1','t2','v2'}, 'dummy', 0));

h.show