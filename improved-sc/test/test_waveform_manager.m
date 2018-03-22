clc
close all
clipboard('copy', 'D:\raw_data\mat\DENR150506')
clear classes
h = sc_tool.PlotManager;
h.signal1.waveforms.add(ScWaveform(h.signal1, 'dummy', []));

h.plot_mode = sc_tool.PlotModeEnum.edit_threshold