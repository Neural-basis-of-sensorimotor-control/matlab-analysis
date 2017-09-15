clear
close all

paired_load_constants

dt = .02;
t = 0:dt:1;
y = sin(t);

plot(t, y);

cr = ClickRecorder(gca, 4);

cr.init_plot();
