clc
clf('reset')
clear classes
d=load('C:\Users\hamo\Documents\MATLAB_minus_one\BBNR_sc.mat');
sequence = d.obj.get(1).get(1);
mgr = sc_gui.WaveformViewer(sequence);
mgr.show();
