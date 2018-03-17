clc
close all
clipboard('copy', 'D:\raw_data\mat\BGNR140131')
clear classes
h = PlotManager;
h.signal1.waveforms.add(ScWaveform(h.signal1, 'dummy', []);

h.plot_mode = PlotModeEnum.add_threshold